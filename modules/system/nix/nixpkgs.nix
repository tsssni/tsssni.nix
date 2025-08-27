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
    cudaSupport = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      config = {
        allowUnfree = true;
        cudaSupport = cfg.cudaSupport;
      };
      overlays = (import ../../../pkgs lib);
    };
  };
}
