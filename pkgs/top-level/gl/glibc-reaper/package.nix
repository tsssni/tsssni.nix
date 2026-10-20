{
  pkgsi686Linux,
  store-prune,
}:
store-prune pkgsi686Linux.glibc {
  paths = [
    "lib/gconv/*.so"
    "share/i18n"
  ];
}
