{
  n = split($0, a, "/"); f = a[n]
  if (n > 1 && f ~ /\.res$/) { id = f; sub(/\.res$/, "", id); split(id, p, "_"); if (p[1] != "root" && p[1] != "pool" && p[1] != "res") lang[p[1]] = 1 }
  items[NR] = $0
}
END {
  for (i = 1; i <= NR; i++) {
    n = split(items[i], a, "/"); f = a[n]
    if (f !~ /\.res$/) continue
    id = f; sub(/\.res$/, "", id); split(id, p, "_")
    if ((p[1] in lang) && p[1] != "en") print items[i]
  }
}
