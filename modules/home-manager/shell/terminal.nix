{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.shell.terminal;
  settingsValueType =
    with lib.types;
    oneOf [
      str
      bool
      int
      float
    ];
  file = "${cfg.theme}.nix";
  themes =
    ./kitty-themes
    |> builtins.readDir
    |> lib.filterAttrs (file: type: type == "regular")
    |> lib.attrNames;
  customTheme = builtins.elem file themes;
in
{
  options.tsssni.shell.terminal = {
    enable = lib.mkEnableOption "tsssni.shell.terminal";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "cyyber";
      example = "cyyber";
      description = "theme used by kitty";
    };
    extraSettings = lib.mkOption {
      type = lib.types.attrsOf settingsValueType;
      default = { };
      example = lib.literalExpression ''
        			{
        				scrollback_lines = 10000;
        				enable_audio_bell = false;
        				update_check_interval = 0;
        			}
        			'';
      description = ''
        				Configuration written to
        				{file}`$XDG_CONFIG_HOME/kitty/kitty.conf`. See
        				<https://sw.kovidgoyal.net/kitty/conf.html>
        				for the documentation.
        			'';
    };
  };

  config.programs.kitty = lib.mkIf cfg.enable {
    enable = true;
    keybindings = {
      "ctrl+t" = "new_tab";
      "ctrl+q" = "close_tab";
      "ctrl+j" = "previous_tab";
      "ctrl+k" = "next_tab";
    };
    themeFile = if customTheme then null else cfg.theme;
    settings =
      { }
      // {
        # font
        font_family = config.tsssni.visual.font.latinFont.name;
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        # tab
        allow_remote_control = "yes";

        # window
        confirm_os_window_close = 0;
        macos_option_as_alt = "left";
      }
      // (lib.optionalAttrs customTheme (import ./kitty-themes/${file}))
      // cfg.extraSettings;
  };
}
