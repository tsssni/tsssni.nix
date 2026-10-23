{
  pkgsi686Linux,
  store-prune,
}:
store-prune pkgsi686Linux.glibc {
  paths = [ "share/i18n" ];
}
