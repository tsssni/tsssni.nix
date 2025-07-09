{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nix.nixpkgs;
in
{
  options.tsssni.nix.nixpkgs = {
    enable = lib.mkEnableOption "tsssni.nix.nixpkgs";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = (import ../../../pkgs lib);
    };
  };
}
