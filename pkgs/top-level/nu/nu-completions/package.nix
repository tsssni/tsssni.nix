{
  lib,
  runCommand,
  nu_scripts,
  completions ? [ ],
}:
runCommand "nu-completions" { } ''
  mkdir -p $out/share/nu-completions
  cp -r ${
    completions
    |> map (x: "${nu_scripts}/share/nu_scripts/custom-completions/${x}")
    |> lib.concatStringsSep " "
  } $out/share/nu-completions/
''
