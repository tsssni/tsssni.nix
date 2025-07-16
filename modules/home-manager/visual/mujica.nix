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
    home.packages = with pkgs; [
      mpv
    ];
  };
}
