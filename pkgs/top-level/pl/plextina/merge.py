import io
import logging
import sys
from fontTools import merge, subset
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont, newTable
from fontTools.ttLib.scaleUpem import scale_upem

logging.getLogger("fontTools").setLevel(logging.ERROR)

KEEP = {"GlyphOrder", "cmap", "head", "hhea", "hmtx", "maxp", "name", "OS/2", "post", "glyf", "loca"}
LAYOUT = {"GDEF", "GSUB", "GPOS"}
VERTICAL = {"vhea", "vmtx"}


def truetype(font):
    order = font.getGlyphOrder()
    glyphs = font.getGlyphSet()
    glyf = newTable("glyf")
    glyf.glyphOrder = order
    glyf.glyphs = {}
    for name in order:
        pen = TTGlyphPen(glyphs)
        glyphs[name].draw(Cu2QuPen(pen, 1.0, reverse_direction=True))
        glyf[name] = pen.glyph()
    font["glyf"] = glyf
    font["loca"] = newTable("loca")
    font["head"].glyphDataFormat = 0
    font.sfntVersion = "\x00\x01\x00\x00"
    del font["CFF "]


def vertical(font):
    upem = font["head"].unitsPerEm
    origin = round(upem * 0.88)
    glyphs = font.getGlyphSet()
    vmtx = newTable("vmtx")
    vmtx.metrics = {}
    for name in font.getGlyphOrder():
        pen = BoundsPen(glyphs)
        glyphs[name].draw(pen)
        vmtx.metrics[name] = (upem, round(origin - pen.bounds[3]) if pen.bounds else 0)
    vhea = newTable("vhea")
    vhea.tableVersion = 0x00011000
    vhea.ascent = upem // 2
    vhea.descent = -(upem // 2)
    vhea.lineGap = 0
    vhea.advanceHeightMax = upem
    vhea.minTopSideBearing = vhea.minBottomSideBearing = vhea.yMaxExtent = 0
    vhea.caretSlopeRise, vhea.caretSlopeRun, vhea.caretOffset = 0, 1, 0
    vhea.reserved1 = vhea.reserved2 = vhea.reserved3 = vhea.reserved4 = 0
    vhea.metricDataFormat = 0
    vhea.numberOfVMetrics = len(vmtx.metrics)
    font["vhea"] = vhea
    font["vmtx"] = vmtx


def load(path, upem, keep, unicodes=None):
    font = TTFont(path)
    if unicodes is not None:
        options = subset.Options()
        options.layout_features = ["*"] if keep & LAYOUT else []
        options.name_IDs = ["*"]
        options.notdef_outline = True
        subsetter = subset.Subsetter(options)
        subsetter.populate(unicodes=unicodes)
        subsetter.subset(font)
    if "CFF " in font:
        truetype(font)
    for glyph in font["glyf"].glyphs.values():
        glyph.removeHinting()
    if font["head"].unitsPerEm != upem:
        scale_upem(font, upem)
    if keep & VERTICAL and "vmtx" not in font:
        vertical(font)
    for tag in set(font.keys()) - keep:
        del font[tag]
    maxp = font["maxp"]
    maxp.tableVersion = 0x00010000
    maxp.maxZones = 1
    for attr in ("maxTwilightPoints", "maxStorage", "maxFunctionDefs", "maxInstructionDefs",
                 "maxStackElements", "maxSizeOfInstructions", "maxComponentElements", "maxComponentDepth"):
        setattr(maxp, attr, 0)
    post = font["post"]
    post.formatType = 2.0
    post.extraNames = []
    post.mapping = {}
    post.glyphOrder = font.getGlyphOrder()
    buf = io.BytesIO()
    font.save(buf)
    buf.seek(0)
    return buf


args = sys.argv[1:]
layout = args[0] == "--layout"
family, path, *rest, out = args[layout:]
base = TTFont(path)
font = TTFont(path)
if rest:
    upem = base["head"].unitsPerEm
    extra = KEEP | (LAYOUT | VERTICAL if layout else set())
    seen = set(base.getBestCmap())
    fonts = [load(path, upem, KEEP | LAYOUT | (VERTICAL if layout else set()))]
    for f in rest:
        unicodes = set(TTFont(f).getBestCmap()) - seen
        seen |= unicodes
        fonts.append(load(f, upem, extra, unicodes))
    font = merge.Merger().merge(fonts)

for tag, attrs in {
    "hhea": ("ascent", "descent", "lineGap"),
    "OS/2": ("sTypoAscender", "sTypoDescender", "sTypoLineGap", "usWinAscent", "usWinDescent", "xAvgCharWidth"),
}.items():
    for attr in attrs:
        setattr(font[tag], attr, getattr(base[tag], attr))

old = base["name"].getBestFamilyName()
for record in font["name"].names:
    record.string = (
        record.toUnicode()
        .replace(old, family)
        .replace(old.replace(" ", ""), family.replace(" ", ""))
    )

font.save(out)
