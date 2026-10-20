{
  lib,
  runCommand,
  nu_scripts,
  completions ? [ ],
}:
runCommand "nu-completions"
  {
    meta = {
      inherit (nu_scripts.meta) platforms;
      hydraPlatforms = [ ];
    };
  }
  ''
    mkdir -p $out/share/nu-completions
    ${lib.optionalString (completions != [ ]) ''
      cp -r ${
        completions
        |> map (x: "${nu_scripts}/share/nu_scripts/custom-completions/${x}")
        |> lib.concatStringsSep " "
      } $out/share/nu-completions/
    ''}
  ''
