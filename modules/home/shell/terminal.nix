{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.shell.terminal;
  homeCfg = config.tsssni.home;
  colorCfg = config.tsssni.visual.color;
  fontCfg = config.tsssni.visual.font;
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
in
{
  options.tsssni.shell.terminal = {
    enable = lib.mkEnableOption "tsssni.shell.terminal";
    extraSettings = lib.mkOption {
      inherit (keyValue) type;
      default = { };
      example = lib.literalExpression ''
        {
          theme = "catppuccin-mocha";
          font-size = 10;
          keybind = [
            "ctrl+h=goto_split:left"
            "ctrl+l=goto_split:right"
          ];
        }
      '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/ghostty/config`.

        See <https://ghostty.org/docs/config/reference> for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    tsssni.visual.font.enable = true;
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
        theme = "plana";
        font-family = [
          fontCfg.nerdFont.name
          fontCfg.latinFont.name
        ];
        font-size = fontCfg.nerdFont.size;
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
      // cfg.extraSettings;
      themes.plana = {
        palette = builtins.genList (i: "${toString i}=${builtins.elemAt colorCfg.palette i}") 16;
        foreground = colorCfg.foreground;
        background = colorCfg.background;
        selection-background = colorCfg.lightBlack;
        cursor-color = colorCfg.lightBlack;
        cursor-text = colorCfg.lightWhite;
      };
    };
  };
}
