{
  gettext,
  store-prune,
}:
store-prune gettext {
  paths = [
    "lib"
    "libexec"
    "share"
  ];
  post = "find bin -mindepth 1 ! -name gettext ! -name ngettext ! -name envsubst ! -name gettext.sh -delete";
}
