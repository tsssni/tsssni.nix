{
  emptyDirectory,
  qt6Packages,
  addons ? [ ],
}:
qt6Packages.fcitx5-with-addons.override {
  inherit addons;
  libsForQt5.fcitx5-qt = emptyDirectory;
  withConfigtool = false;
}
