{
  replaceDirectDependencies,
  runCommandLocal,
  nix,
}:
replaceDirectDependencies.override {
  inherit nix;
  runCommandLocal =
    name: env: cmd:
    runCommandLocal name env (
      builtins.replaceStrings
        [ ''basename "$1"'' ''basename "$2"'' ]
        [
          ''basename "$1" | cut -c1-32''
          ''basename "$2" | cut -c1-32''
        ]
        cmd
    );
}
