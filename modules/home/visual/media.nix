{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.media;
in
{
  options.tsssni.visual.media = {
    enable = lib.mkEnableOption "tsssni.visual.mujica";
  };

  config = lib.mkIf cfg.enable {
    programs.mpv.enable = true;
    home.packages = with pkgs; [
      go-musicfox
      tev
    ];
  };
}
