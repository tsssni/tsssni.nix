{
  lib,
}:
let
  entries = builtins.readDir ./.;
in
builtins.foldl' (acc: name: acc // import ./${name} { inherit lib; }) { } (
  builtins.filter (
    name:
    (entries.${name} == "directory")
    || (entries.${name} == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null)
  ) (builtins.attrNames entries)
)
