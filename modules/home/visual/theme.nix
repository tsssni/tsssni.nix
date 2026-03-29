{
  lib,
  pkgs,
  config,
  ...
}:
let
  guiCfg = config.tsssni.visual.theme.gui;
  tuiCfg = config.tsssni.visual.theme.tui;
  colorOption =
    default:
    lib.mkOption {
      type = (with lib.types; nullOr str);
      inherit default;
    };
  foreground = "#bebad9";
  background = "#303446";
  palette = [
    "#1a1730"
    "#f26dab"
    "#8ec794"
    "#e5c890"
    "#8499d9"
    "#a78dd4"
    "#7dd5d5"
    "#bebad9"
    "#514c73"
    "#ff8d7c"
    "#a8e5af"
    "#f5dba8"
    "#a0b4e5"
    "#c0a8e8"
    "#9fe5e5"
    "#d5d1e6"
  ];
  colorList = [
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
    "lightBlack"
    "lightRed"
    "lightGreen"
    "lightYellow"
    "lightBlue"
    "lightMagenta"
    "lightCyan"
    "lightWhite"
  ];
in
{
  options.tsssni.visual.theme = {
    gui = {
      enable = lib.mkEnableOption "tsssni.visual.theme.gui";
      cursor = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            options = {
              package = lib.mkOption { type = lib.types.package; };
              name = lib.mkOption { type = lib.types.str; };
              size = lib.mkOption {
                type = lib.types.int;
                default = 24;
              };
            };
          }
        );
        default = {
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 24;
        };
      };

      window = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            options = {
              package = lib.mkOption { type = lib.types.package; };
              name = lib.mkOption { type = lib.types.str; };
            };
          }
        );
        default = {
          package = pkgs.fluent-gtk-theme;
          name = "Fluent";
        };
      };

      icon = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            options = {
              package = lib.mkOption { type = lib.types.package; };
              name = lib.mkOption { type = lib.types.str; };
            };
          }
        );
        default = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };
    };

    tui = {
      enable = lib.mkEnableOption "tsssni.visual.theme.tui";
      font = {
        nerdFont = lib.mkOption {
          type = lib.hm.types.fontType;
          default = {
            package = pkgs.nerd-fonts.blex-mono;
            name = "BlexMono Nerd Font";
            size = 16;
          };
        };
        latinFont = lib.mkOption {
          type = lib.hm.types.fontType;
          default = {
            package = pkgs.ibm-plex;
            name = "IBM Plex Mono";
            size = 16;
          };
        };
        emojiFont = lib.mkOption {
          type = lib.hm.types.fontType;
          default = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
            size = 16;
          };
        };
      };

      color = {
        palette = lib.mkOption {
          type = with lib.types; listOf str;
          default = palette;
        };
        foreground = colorOption foreground;
        background = colorOption background;
      }
      // builtins.listToAttrs (
        map (x: {
          name = x;
          value = colorOption null;
        }) colorList
      );
    };
  };

  config = lib.mkIf (guiCfg.enable || tuiCfg.enable) {
    home = {
      packages =
        [ ]
        ++ lib.optionals guiCfg.enable (
          with pkgs;
          [
            xdg-utils
            dconf
          ]
        )
        ++ lib.optionals tuiCfg.enable (
          with tuiCfg.font;
          [
            nerdFont.package
            latinFont.package
            emojiFont.package
          ]
        );
      pointerCursor = lib.mkIf guiCfg.enable (
        {
          gtk.enable = true;
        }
        // guiCfg.cursor
      );
    };

    gtk = lib.mkIf guiCfg.enable rec {
      enable = true;
      theme = guiCfg.window;
      iconTheme = guiCfg.icon;
      font = tuiCfg.font.latinFont;
      colorScheme = "dark";
      gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4 = {
        inherit theme;
        extraConfig.gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = lib.mkIf guiCfg.enable {
      enable = true;
      platformTheme.name = "gtk";
    };

    tsssni.visual.theme.tui.color = lib.mkIf tuiCfg.enable (
      builtins.listToAttrs (
        lib.imap0 (i: x: {
          name = x;
          value = lib.mkDefault (builtins.elemAt tuiCfg.color.palette i);
        }) colorList
      )
    );
  };
}
