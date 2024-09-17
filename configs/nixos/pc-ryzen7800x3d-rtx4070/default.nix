{
  inputs
, tsssni
, host
}:
import ../rebuild.nix {
  inherit inputs tsssni host;
  system = "x86_64-linux";
  extraHomeManagerModules = with inputs; [
    nixvim.homeManagerModules.nixvim
    ags.homeManagerModules.ags
  ];
}
