{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.science;
  python = pkgs.python3.withPackages (
    ps: with ps; [
      mlx
      numpy
      openimageio
    ]
  );
in
{
  options.tsssni.devel.science = {
    enable = lib.mkEnableOption "tsssni.devel.science";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ python ];
  };
}
