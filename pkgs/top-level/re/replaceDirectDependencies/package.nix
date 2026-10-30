{
  lib,
  stdenv,
  darwin,
  replaceDirectDependencies,
  runCommandLocal,
  nix,
}:
replaceDirectDependencies.override {
  inherit nix;
  runCommandLocal =
    name: env: cmd:
    runCommandLocal name
      (
        env
        // {
          nativeBuildInputs =
            (env.nativeBuildInputs or [ ])
            ++ lib.optional stdenv.hostPlatform.isDarwin darwin.autoSignDarwinBinariesHook;
        }
      )
      (
        builtins.replaceStrings
          [ ''basename "$1"'' ''basename "$2"'' ]
          [
            ''basename "$1" | cut -c1-32''
            ''basename "$2" | cut -c1-32''
          ]
          cmd
        + lib.optionalString stdenv.hostPlatform.isDarwin ''
          chmod -R u+w "$out"
          signDarwinBinariesIn "$out"
        ''
      );
}
