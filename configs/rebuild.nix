{
  inputs,
  distro,
  func,
  eval,
  system,
  config,
  modules,
  root,
}@args:
let
  prelude = import ./prelude.nix args;
  glob = import ./glob.nix modules.home folder;
  lib = inputs.nixpkgs.lib.extend (final: prev: import ../lib { lib = prev; });
  folder = "${distro}/${func}";
  pkgs = import inputs.nixpkgs { inherit system config; };
  hydra = lib.optional (builtins.pathExists ./${folder}/hydra.nix) ./${folder}/hydra.nix;
in
eval (
  if (distro != "home") then
    {
      inherit lib system;
      modules =
        modules.system
        ++ hydra
        ++ lib.optional (!root) glob
        ++ [
          ./${folder}/system
          prelude
        ];
    }
  else
    {
      inherit lib pkgs;
      modules =
        modules.home
        ++ hydra
        ++ [
          ./${folder}
          prelude
        ];
    }
)
