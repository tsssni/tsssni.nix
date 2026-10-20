{
  glibc,
  store-prune,
}:
store-prune glibc { paths = [ "lib/gconv/*.so" ]; }
