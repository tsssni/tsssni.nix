{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.widget;
in
{
  options.tsssni.visual.widget = {
    enable = lib.mkEnableOption "tsssni.visual.widget";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tsssni.astal
    ];
  };
}
