{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.file;
  homeCfg = config.tsssni.home;
  shellCfg = config.tsssni.shell.shell;
  windowCfg = config.tsssni.visual.window;
in
{
  options.tsssni.visual.file = {
    enable = lib.mkEnableOption "tsssni.visual.file";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      package = if homeCfg.standalone then null else pkgs.yazi.override { optionalDeps = [ ]; };
      enableNushellIntegration = shellCfg.enable;
      shellWrapperName = "yy";
    };
    xdg = lib.optionalAttrs windowCfg.enable {
      configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        env=TERMCMD=ghostty -e
      '';
      portal = {
        config.niri."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
      };
    };
  };
}
