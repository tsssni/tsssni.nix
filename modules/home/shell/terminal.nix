{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.shell.terminal;
  homeCfg = config.tsssni.home;
  color = config.tsssni.visual.color;
  font = config.tsssni.visual.font;
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
          font.nerdFont.name
          font.latinFont.name
        ];
        font-size = font.nerdFont.size;
        window-decoration = "none";
        window-inherit-working-directory = false;
        confirm-close-surface = false;
        macos-option-as-alt = true;
        maximize = pkgs.stdenv.isDarwin;
        keybind = [
            "cmd+c=copy_to_clipboard"
            "cmd+v=paste_from_clipboard"
        ];
      }
      // cfg.extraSettings;
      themes.plana = {
        palette = builtins.genList (i: "${toString i}=${builtins.elemAt color.palette i}") 16;
        foreground = color.foreground;
        background = color.background;
        selection-background = color.lightBlack;
        cursor-color = color.lightBlack;
        cursor-text = color.lightWhite;
      };
    };
  };
}
