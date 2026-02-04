{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.wired.cloud;
in
{
  options.tsssni.wired.cloud = {
    enable = lib.mkEnableOption "tsssni.wired.cloud";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      clouddrive2
    ];
  };
}
