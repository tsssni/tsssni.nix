import sys
from fontTools import subset
from fontTools.ttLib import TTFont

*bases, target = sys.argv[1:]
base = set().union(*(TTFont(f).getBestCmap() for f in bases))
font = TTFont(target)
options = subset.Options()
options.layout_features = ["*"]
options.name_IDs = ["*"]
options.name_languages = ["*"]
options.notdef_outline = True
subsetter = subset.Subsetter(options)
subsetter.populate(unicodes=set(font.getBestCmap()) - base)
subsetter.subset(font)
font.save(target)
