{
  inputs
, tsssni
, host
}:
import ../rebuild.nix {
  inherit inputs tsssni host;
  system = "aarch64-darwin";
  extraHomeManagerModules = with inputs; [
    nixvim.homeManagerModules.nixvim
    ags.homeManagerModules.ags
  ];
}
