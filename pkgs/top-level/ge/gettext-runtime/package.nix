{
  lib,
  stdenv,
  gettext,
  store-prune,
}:
store-prune gettext {
  paths = [
    "libexec"
    "share"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) "lib";
  post = ''
    find bin -mindepth 1 ! -name gettext ! -name ngettext ! -name envsubst ! -name gettext.sh -delete
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      find lib -mindepth 1 -maxdepth 1 ! -name 'libintl*.dylib' -exec rm -rf {} +
    ''}
  '';
}
