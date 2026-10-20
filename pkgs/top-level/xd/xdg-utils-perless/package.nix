{
  xdg-utils,
  store-prune,
}:
store-prune xdg-utils {
  paths = [ "bin/xdg-screensaver" ];
  post = "sed -i -e '/PERL5LIB/d' -e 's|:/nix/store/[a-z0-9]*-perl[^:]*||g' bin/xdg-mime";
}
