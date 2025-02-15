{
  inputs
, tsssni
, func
}:
import ../rebuild.nix {
  inherit inputs tsssni func;
  system = "aarch64-darwin";
  extraSystemModules = with inputs; [
    agenix.darwinModules.age
  ];
  extraHomeManagerModules = with inputs; [
    nixvim.homeManagerModules.nixvim
    ags.homeManagerModules.ags
  ];
}
