{
  gitMinimal,
  store-prune,
}:
store-prune gitMinimal {
  paths = [
    "share/git-gui"
    "share/gitk"
    "bin/{git-cvsserver,git-http-backend,git-shell,scalar}"
    "libexec/git-core/{git-citool,git-gui*,gitk*,git-cvsserver*,git-daemon,git-http-backend,git-http-fetch,git-http-push,git-imap-send,git-shell,scalar}"
  ];
}
