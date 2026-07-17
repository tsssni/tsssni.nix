{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.intef.terminal;
  homeCfg = config.tsssni.home;
  literatureCfg = config.tsssni.devel.literal;
  colorCfg = literatureCfg.color;
  fontCfg = literatureCfg.font;
in
{
  options.tsssni.intef.terminal.enable = lib.mkEnableOption "tsssni.intef.terminal";

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package =
        with pkgs;
        if homeCfg.standalone then
          null
        else if stdenv.isLinux then
          ghostty
        else
          ghostty-bin;
      systemd.enable = pkgs.stdenv.isLinux && !homeCfg.standalone;
      clearDefaultKeybinds = true;
      settings = {
        window-decoration = "none";
        window-inherit-working-directory = false;
        confirm-close-surface = false;
        macos-option-as-alt = true;
        maximize = pkgs.stdenv.isDarwin;
        keybind = [
          "cmd+c=copy_to_clipboard"
          "cmd+v=paste_from_clipboard"
          "ctrl+equal=increase_font_size:1"
          "ctrl+minus=decrease_font_size:1"
        ];
        theme = lib.mkIf literatureCfg.enable "plana";
        font-family = lib.mkIf literatureCfg.enable [
          fontCfg.nerdFont.name
          fontCfg.latinFont.name
          fontCfg.hanzisFont.name
          fontCfg.hanzitFont.name
          fontCfg.kanjiFont.name
          fontCfg.hangulFont.name
        ];
        font-size = lib.mkIf literatureCfg.enable fontCfg.nerdFont.size;
      };
      themes = lib.mkIf literatureCfg.enable {
        plana = {
          palette = builtins.genList (i: "${toString i}=${builtins.elemAt colorCfg.palette i}") 16;
          foreground = colorCfg.foreground;
          background = colorCfg.background;
          selection-background = colorCfg.lightBlack;
          cursor-color = colorCfg.lightBlack;
          cursor-text = colorCfg.lightWhite;
        };
      };
    };
  };
}
