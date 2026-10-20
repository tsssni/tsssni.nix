{
  systemdMinimal,
  store-prune,
}:
store-prune systemdMinimal {
  post = ''
    find . -mindepth 1 -maxdepth 1 ! -name lib -exec rm -rf {} +
    find lib -mindepth 1 -maxdepth 1 ! -name 'libsystemd.so*' ! -name 'libudev.so*' -exec rm -rf {} +
  '';
}
