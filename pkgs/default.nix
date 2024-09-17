{ nixpkgs }:
{
  localSystem
, crossSystem ? localSystem
, config ? {}
}:
let
  pkgs = import nixpkgs {
    inherit
      localSystem
      crossSystem
      config
    ;
  };
  lib = nixpkgs.lib;
  fullLocalSystem = lib.systems.elaborate localSystem;
  fullCrossSystem = lib.systems.elaborate crossSystem;
in with pkgs; {
  darwin = callPackage ./darwin {};
  gnu = callPackage ./gnu {};
  sketchybar-lua = callPackage ./visual/sketchybar-lua.nix {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation;
  };

  tsssni-grub-theme = callPackage ./visual/tsssni-grub-theme.nix {};
  vimPlugins = callPackage ./nixvim {};
  vscode-extensions = callPackage ./vscode {};
}
