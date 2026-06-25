{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.intef.window;
  literatureCfg = config.tsssni.devel.literal;
  colorCfg = literatureCfg.color;

  fzfPicker = lib.getExe (
    pkgs.writeShellApplication {
      name = "fzf-picker";
      runtimeInputs = with pkgs; [
        fzf
        fd
        coreutils
      ];
      text = ''
        multiple="$1"
        directory="$2"
        save="$3"
        path="$4"
        out="$5"

        if [ "$save" = "1" ]; then
          printf '%s' "$path" > "$out"
          exit
        fi

        if [ "$directory" = "1" ]; then
          fd -a --base-directory="$HOME" -td | fzf +m --prompt 'Select directory > ' > "$out"
        elif [ "$multiple" = "1" ]; then
          fd -a --base-directory="$HOME" | fzf -m --prompt 'Select files > ' > "$out"
        else
          fd -a --base-directory="$HOME" | fzf +m --prompt 'Select file > ' > "$out"
        fi
      '';
    }
  );

  monitorKdl =
    key: monitor:
    let
      join = nodes: lib.concatMapStringsSep " " (n: "${n};") (lib.filter (s: s != "") nodes);
      name = if monitor.name != null then monitor.name else key;
      rotation = monitor.transform.rotation;
      fliprot = lib.concatStrings [
        (lib.optionalString monitor.transform.flipped "flipped")
        (lib.optionalString (monitor.transform.flipped && rotation != 0) "-")
        (lib.optionalString (rotation != 0) (toString rotation))
      ];
      scale = lib.optionalString (monitor.scale != null) "scale ${toString monitor.scale}";
      position = lib.optionalString (
        monitor.position != null
      ) "position x=${toString monitor.position.x} y=${toString monitor.position.y}";
      transform = lib.optionalString (fliprot != "") ''transform "${fliprot}"'';
      refresh = lib.optionalString (monitor.refresh != null) "@${toString monitor.refresh}";
      mode = lib.optionalString (
        monitor.width != null && monitor.height != null
      ) ''mode "${toString monitor.width}x${toString monitor.height}${refresh}"'';
      body = join [
        scale
        position
        transform
        mode
      ];
    in
    ''output "${name}" { ${body} }'';
  outputsKdl = lib.concatStringsSep "\n\n" (lib.mapAttrsToList monitorKdl cfg.monitors);

  borderKdl = lib.optionalString literatureCfg.enable (
    lib.concatStringsSep "\n" [
      ''active-color "${colorCfg.lightBlack}"''
      ''inactive-color "${colorCfg.lightBlack}"''
      ''urgent-color "${colorCfg.lightBlack}"''
    ]
  );
  focusRingKdl =
    let
      gradient = ''from="${colorCfg.lightBlue}" to="${colorCfg.lightCyan}" angle=180 relative-to="workspace-view"'';
    in
    lib.optionalString literatureCfg.enable (
      lib.concatStringsSep "\n" [
        "active-gradient ${gradient}"
        "inactive-gradient ${gradient}"
        "urgent-gradient ${gradient}"
      ]
    );

  niriKdl = ''
    input {
        keyboard { xkb { layout "us"; options "caps:ctrl_modifier"; }; }
        focus-follows-mouse max-scroll-amount="10%"
        disable-power-key-handling
    }

    ${outputsKdl}

    gestures { hot-corners { off; }; }

    layout {
        gaps 10
        background-color "transparent"
        always-center-single-column false
        default-column-display "normal"
        default-column-width { proportion 0.5; }
        preset-column-widths { proportion ${toString (1.0 / 3.0)}; proportion 0.5; proportion ${toString (2.0 / 3.0)}; }
        preset-window-heights { proportion 0.5; proportion 1.0; }
        border {
            width 2
            ${borderKdl}
        }
        focus-ring {
            width 5
            ${focusRingKdl}
        }
        shadow { off; }
    }

    animations {
        window-open { duration-ms 500; curve "ease-out-cubic"; }
        window-close { duration-ms 700; curve "ease-out-expo"; }
        window-movement { spring damping-ratio=0.8 stiffness=200 epsilon=0.001; }
    }

    window-rule { clip-to-geometry true; geometry-corner-radius 20.0; }
    prefer-no-csd
    layer-rule { match namespace="^awww"; place-within-backdrop true; }
    layer-rule { match namespace="^april-shell$"; background-effect { blur true; }; }

    binds {
        Mod+Z { spawn-sh "april-shell ipc call toggleBlurryPlayer toggle"; }
        Mod+T { spawn "ghostty"; }
        Mod+B { spawn "firefox"; }
        Mod+G { spawn "steam"; }
        Mod+Q { quit skip-confirmation=true; }
        Mod+P { screenshot show-pointer=false; }
        Mod+W { screenshot-window write-to-disk=true; }
        Mod+O { toggle-overview; }
        Mod+M { maximize-column; }
        Mod+F { fullscreen-window; }
        Mod+X { close-window; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+Down { focus-workspace-down; }
        Mod+Up { focus-workspace-up; }

        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+L { move-column-right; }
        Mod+Ctrl+J { move-window-down; }
        Mod+Ctrl+K { move-window-up; }
        Mod+Ctrl+F { toggle-window-floating; }
        Mod+Ctrl+X { center-column; }
        Mod+Ctrl+I { consume-or-expel-window-left; }
        Mod+Ctrl+O { consume-or-expel-window-right; }
        Mod+Ctrl+Down { move-window-to-workspace-down; }
        Mod+Ctrl+Up { move-window-to-workspace-up; }

        Mod+Alt+H { switch-preset-column-width; }
        Mod+Alt+L { maximize-column; }
        Mod+Alt+J { switch-preset-window-height; }
        Mod+Alt+K { reset-window-height; }

        Mod+WheelScrollUp { focus-column-left; }
        Mod+WheelScrollDown { focus-column-right; }
    }
  '';
in
{
  options.tsssni.intef.window = {
    enable = lib.mkEnableOption "tsssni.intef.window";

    monitors = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            name = lib.mkOption {
              type = nullOr str;
              default = null;
            };
            width = lib.mkOption {
              type = nullOr int;
              default = null;
            };
            height = lib.mkOption {
              type = nullOr int;
              default = null;
            };
            refresh = lib.mkOption {
              type = nullOr float;
              default = null;
            };
            scale = lib.mkOption {
              type = nullOr float;
              default = null;
            };
            transform = {
              flipped = lib.mkOption {
                type = bool;
                default = false;
              };
              rotation = lib.mkOption {
                type = enum [
                  0
                  90
                  180
                  270
                ];
                default = 0;
              };
            };
            position = lib.mkOption {
              type = nullOr (submodule {
                options = {
                  x = lib.mkOption { type = int; };
                  y = lib.mkOption { type = int; };
                };
              });
              default = null;
            };
            wallpaper = lib.mkOption {
              type = nullOr path;
              default = null;
            };
          };
        });
      default = { };
    };

    sunset = {
      enable = lib.mkEnableOption "tsssni.intef.window.sunset";
      coordinate = {
        latitude = lib.mkOption {
          type = lib.types.float;
          default = 35.6620;
        };
        longitude = lib.mkOption {
          type = lib.types.float;
          default = 139.7038;
        };
      };
      temperature = {
        day = lib.mkOption {
          type = lib.types.int;
          default = 6504;
        };
        night = lib.mkOption {
          type = lib.types.int;
          default = 3450;
        };
      };
    };

    theme = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.fluent-gtk-theme;
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Fluent";
      };
    };

    icon = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.adwaita-icon-theme;
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Adwaita";
      };
    };

    cursor = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.apple-cursor;
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "macOS";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    tsssni.intef.shell.environmentVariables = {
      XCURSOR_SIZE = cfg.cursor.size;
      XCURSOR_THEME = cfg.cursor.name;
      QT_QPA_PLATFORMTHEME = "qt5ct";
      XDG_SESSION_TYPE = "wayland";
    };

    services = {
      awww.enable = true;
      wlsunset = {
        inherit (cfg.sunset) enable temperature;
      }
      // cfg.sunset.coordinate;
    };

    systemd.user.services = {
      april-shell = {
        Unit = {
          Description = "april-shell";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.april-shell}";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      awww-wallpaper = {
        Unit = {
          Description = "awww-wallpaper";
          After = [ "awww.service" ];
          Requires = [ "awww.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.mapAttrsToList (
            monitor: value:
            let
              wallpaper = if value.wallpaper != null then value.wallpaper else ./config/wallpaper/moonscape.png;
            in
            "${lib.getExe pkgs.awww} img ${wallpaper} -o ${monitor} --transition-type none"
          ) cfg.monitors;
        };
        Install.WantedBy = [ "awww.service" ];
      };
    };

    xdg = {
      configFile = {
        "niri/config.kdl".text = niriKdl;
        "xdg-desktop-portal-termfilechooser/config".text = ''
          [filechooser]
          cmd=${pkgs.writeShellScript "fzf-wrapper.sh" ''
            ${lib.getExe pkgs.ghostty} -e ${fzfPicker} "$@"
          ''}
        '';
      };
      portal = {
        config.niri."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
      };
    };

    gtk = rec {
      enable = true;
      theme = cfg.theme;
      iconTheme = cfg.icon;
      font = literatureCfg.font.latinFont;
      colorScheme = "dark";
      gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4 = {
        inherit theme;
        extraConfig.gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    home = {
      packages = with pkgs; [
        niri
        april-shell
        xwayland-satellite
        wl-clipboard
        xdg-utils
        dconf
      ];
      pointerCursor = {
        gtk.enable = true;
      }
      // cfg.cursor;
    };
  };
}
