{
  inputs,
  distro,
  func,
  eval,
  system,
  config,
  modules,
}@args:
let
  prelude = import ./prelude.nix args;
  glob = import ./glob.nix args folder;
  lib = inputs.nixpkgs.lib.extend (final: prev: import ../lib { lib = prev; });
  folder = "${distro}/${func}";
  pkgs = import inputs.nixpkgs { inherit system config; };
in
eval (
  if (distro != "home") then
    {
      inherit lib system;
      modules = modules.system ++ [
        ./${folder}/system
        prelude
        glob
      ];
    }
  else
    {
      inherit lib pkgs;
      modules = modules.home ++ [
        ./${folder}
        prelude
      ];
    }
)
