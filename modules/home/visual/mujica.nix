{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.mujica;
in
{
  options.tsssni.visual.mujica = {
    enable = lib.mkEnableOption "tsssni.visual.mujica";
  };

  config = lib.mkIf cfg.enable {
    programs.mpv.enable = true;
    home.packages = with pkgs; [
      clouddrive2
    ];
  };
}
