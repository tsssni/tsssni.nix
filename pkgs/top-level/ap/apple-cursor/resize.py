import struct
import sys

keep = {int(s) for s in sys.argv[1].split(",")}
for path in sys.argv[2:]:
    data = open(path, "rb").read()
    magic, header, version, ntoc = struct.unpack_from("<4sIII", data)
    toc = [struct.unpack_from("<III", data, header + 12 * i) for i in range(ntoc)]

    def chunk(kind, pos):
        if kind == 0xFFFD0002:
            w, h = struct.unpack_from("<II", data, pos + 16)
            return data[pos : pos + 36 + 4 * w * h]
        n = struct.unpack_from("<I", data, pos + 16)[0]
        return data[pos : pos + 20 + n]

    entries = [(k, s, chunk(k, p)) for k, s, p in toc if k != 0xFFFD0002 or s in keep]
    pos = header + 12 * len(entries)
    out = [struct.pack("<4sIII", magic, header, version, len(entries))]
    body = []
    for k, s, c in entries:
        out.append(struct.pack("<III", k, s, pos))
        body.append(c)
        pos += len(c)
    open(path, "wb").write(b"".join(out + body))
