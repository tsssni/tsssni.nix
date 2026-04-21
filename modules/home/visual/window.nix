{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.window;
  tuiCfg = config.tsssni.visual.theme.tui;
  colorCfg = tuiCfg.color;
  shellCfg = config.tsssni.shell.shell;
  zellijCfg = config.programs.zellij;

  monitorName = key: monitor: if monitor.name != null then monitor.name else key;
  hasWallpaper = lib.any (monitor: monitor.wallpaper != null) (lib.attrValues cfg.monitors);

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
  fzfWrapper = pkgs.writeShellScript "fzf-wrapper.sh" ''
    ${lib.getExe pkgs.ghostty} -e ${fzfPicker} "$@"
  '';

  joinLines = lines: lib.concatStringsSep "\n" (lib.filter (s: s != "") lines);
  joinSemi = nodes: lib.concatMapStringsSep " " (n: "${n};") (lib.filter (s: s != "") nodes);

  monitorToKdl =
    key: monitor:
    let
      name = monitorName key monitor;
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
      body = joinSemi [
        scale
        position
        transform
        mode
      ];
    in
    ''output "${name}" { ${body} }'';

  outputsKdl = lib.concatStringsSep "\n\n" (lib.mapAttrsToList monitorToKdl cfg.monitors);

  borderExtraKdl = joinLines [
    (lib.optionalString tuiCfg.enable ''active-color "${colorCfg.lightBlack}"'')
    (lib.optionalString tuiCfg.enable ''inactive-color "${colorCfg.lightBlack}"'')
    (lib.optionalString tuiCfg.enable ''urgent-color "${colorCfg.lightBlack}"'')
  ];

  focusRingExtraKdl =
    let
      gradient = ''from="${colorCfg.lightBlue}" to="${colorCfg.lightCyan}" angle=180 relative-to="workspace-view"'';
    in
    joinLines [
      (lib.optionalString tuiCfg.enable "active-gradient ${gradient}")
      (lib.optionalString tuiCfg.enable "inactive-gradient ${gradient}")
      (lib.optionalString tuiCfg.enable "urgent-gradient ${gradient}")
    ];

  awwwLayerRuleKdl = lib.optionalString hasWallpaper ''
    layer-rule { match namespace="^awww"; place-within-backdrop true; }
  '';

  ghosttySpawnArgs = lib.concatStringsSep " " (
    lib.filter (s: s != "") [
      ''"ghostty"''
      (lib.optionalString shellCfg.enable ''"-e"'')
      (lib.optionalString shellCfg.enable ''"${lib.getExe zellijCfg.package}"'')
    ]
  );

  niriKdl = ''
    xwayland-satellite {
        path "${lib.getExe pkgs.xwayland-satellite-unstable}"
    }

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
            ${borderExtraKdl}
        }
        focus-ring {
            width 5
            ${focusRingExtraKdl}
        }
        shadow { off; }
    }

    animations {
        window-open { duration-ms 500; curve "ease-out-cubic"; }
        window-close { duration-ms 700; curve "ease-out-expo"; }
        window-movement { spring damping-ratio=0.8 stiffness=200 epsilon=0.001; }
    }

    window-rule { clip-to-geometry true; geometry-corner-radius 20.0; }

    window-rule {
        match app-id="ghostty"
        opacity 0.95
        background-effect { blur true; }
        draw-border-with-background false
    }

    prefer-no-csd
    ${awwwLayerRuleKdl}
    layer-rule { match namespace="^april-shell$"; background-effect { blur true; }; }

    binds {
        Mod+Z { spawn-sh "${lib.getExe pkgs.april-shell} ipc call toggleBlurryPlayer toggle"; }
        Mod+T { spawn ${ghosttySpawnArgs}; }
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
  options.tsssni.visual.window = {
    enable = lib.mkEnableOption "tsssni.visual.window";
    monitors = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            name = lib.mkOption {
              type = nullOr str;
              default = null;
              description = "Output name. Defaults to the attribute key.";
            };
            width = lib.mkOption {
              type = nullOr int;
              default = null;
              description = "Output resolution width in pixels.";
            };
            height = lib.mkOption {
              type = nullOr int;
              default = null;
              description = "Output resolution height in pixels.";
            };
            refresh = lib.mkOption {
              type = nullOr float;
              default = null;
              description = "Output refresh rate. When null, picks the highest available.";
            };
            scale = lib.mkOption {
              type = nullOr float;
              default = null;
              description = "Output scale. Represents how many physical pixels fit in one logical pixel.";
            };
            transform = {
              flipped = lib.mkOption {
                type = bool;
                default = false;
                description = "Whether to flip this output vertically.";
              };
              rotation = lib.mkOption {
                type = enum [
                  0
                  90
                  180
                  270
                ];
                default = 0;
                description = "Counter-clockwise rotation of this output in degrees.";
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
              description = "Position in global coordinate space. Affects directional monitor actions and cursor movement.";
            };
            wallpaper = lib.mkOption {
              type = nullOr path;
              default = null;
              description = "Wallpaper image path for this output.";
            };
          };
        });
      default = { };
    };
    sunset = {
      enable = lib.mkEnableOption "tsssni.visual.window.sunset";
      coordinate = {
        latitude = lib.mkOption {
          type = lib.types.float;
          default = 35.6620;
          description = ''
            Your current latitude, between `-90.0` and `90.0`.
          '';
        };
        longitude = lib.mkOption {
          type = lib.types.float;
          default = 139.7038;
          description = ''
            Your current longitude, between `-180.0` and `180.0`.
          '';
        };
      };
      temperature = {
        day = lib.mkOption {
          type = lib.types.int;
          default = 6504;
          description = ''
            Colour temperature to use during the day, in Kelvin (K).
            This value must be greater than `temperature.night`.
          '';
        };
        night = lib.mkOption {
          type = lib.types.int;
          default = 3450;
          description = ''
            Colour temperature to use during the night, in Kelvin (K).
            This value must be smaller than `temperature.day`.
          '';
        };
      };
    };
    shell.enable = lib.mkEnableOption "tsssni.visual.window.shell";
    file.enable = lib.mkEnableOption "tsssni.visual.window.file";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      config = niriKdl;
    };

    services = {
      awww.enable = hasWallpaper;
      wlsunset = {
        inherit (cfg.sunset) enable temperature;
      }
      // cfg.sunset.coordinate;
    };

    systemd.user.services =
      { }
      // lib.optionalAttrs hasWallpaper {
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
              "${lib.getExe pkgs.awww} img ${value.wallpaper} -o ${monitor} --transition-type none"
            ) (lib.filterAttrs (_: v: v.wallpaper != null) cfg.monitors);
          };
          Install.WantedBy = [ "awww.service" ];
        };
      }
      // lib.optionalAttrs cfg.shell.enable {
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
      };

    xdg = lib.optionalAttrs cfg.file.enable {
      configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${fzfWrapper}
      '';
      portal = {
        config.niri."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
      };
    };

    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
