{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.aesth;
in
{
  options.tsssni.visual.aesth = {
    enable = lib.mkEnableOption "tsssni.visual.aesth";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
      gimp3
      unityhub
    ];
  };
}
