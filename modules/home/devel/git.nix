{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.git;
  homeCfg = config.tsssni.home;
  colorCfg = config.tsssni.visual.color;
in
{
  options.tsssni.devel.git = {
    enable = lib.mkEnableOption "tsssni.devel.git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = lib.optionalAttrs (!homeCfg.standalone) {
      enable = true;
      settings = {
        user = {
          name = "tsssni";
          email = "dingyongyu2002@foxmail.com";
        };
        credential.helper = "store";
        rebase.pull = "rebase";
      };
    };
    programs.lazygit = {
      enable = true;
      package = if homeCfg.standalone then null else pkgs.lazygit;
      settings.gui.theme.selectedLineBgColor = [ colorCfg.lightBlack ];
    };
  };
}
