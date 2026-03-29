{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.shell.terminal;
  homeCfg = config.tsssni.home;
  tuiCfg = config.tsssni.visual.theme.tui;
  colorCfg = tuiCfg.color;
  fontCfg = tuiCfg.font;
in
{
  options.tsssni.shell.terminal = {
    enable = lib.mkEnableOption "tsssni.shell.terminal";
  };

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
      }
      // (lib.optionalAttrs tuiCfg.enable {
        theme = "plana";
        font-family = [
          fontCfg.nerdFont.name
          fontCfg.latinFont.name
        ];
        font-size = fontCfg.nerdFont.size;
      });
      themes = lib.optionalAttrs tuiCfg.enable {
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
