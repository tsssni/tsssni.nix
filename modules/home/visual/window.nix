{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.window;
  imeCfg = config.tsssni.visual.ime;
  colorCfg = config.tsssni.visual.color;
  shellCfg = config.tsssni.shell.shell;
  zellijCfg = config.programs.zellij;
  monitorName = key: monitor: if monitor.name != null then monitor.name else key;
  hasWallpaper = lib.any (monitor: monitor.wallpaper != null) (lib.attrValues cfg.monitors);
  settingsType =
    with lib.types;
    let
      valueType =
        nullOr (oneOf [
          bool
          int
          float
          str
          path
          (attrsOf valueType)
          (listOf valueType)
        ])
        // {
          description = "window manager configuration value";
        };
    in
    valueType;
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
    extraSettings = lib.mkOption {
      type = settingsType;
      default = { };
      description = ''
        window manager extra configurations
      '';
      example = lib.literalExpression ''
        {
          outputs."eDP-1".scale = 2.0;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        xwayland-satellite = {
          enable = true;
          path = "${lib.getExe pkgs.xwayland-satellite-unstable}";
        };
        input = {
          keyboard.xkb = {
            layout = "us";
            options = "caps:ctrl_modifier";
          };
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "10%";
          };
          power-key-handling.enable = false;
        };
        outputs = lib.mapAttrs' (
          key: monitor:
          lib.nameValuePair (monitorName key monitor) {
            inherit (monitor) scale transform position;
            mode = {
              inherit (monitor) width height refresh;
            };
          }
        ) cfg.monitors;
        gestures = {
          hot-corners.enable = false;
        };
        layout = {
          preset-column-widths = [
            { proportion = 1.0 / 3.0; }
            { proportion = 1.0 / 2.0; }
            { proportion = 2.0 / 3.0; }
          ];
          preset-window-heights = [
            { proportion = 1.0 / 2.0; }
            { proportion = 1.0 / 1.0; }
          ];
          always-center-single-column = false;
          default-column-display = "normal";
          default-column-width.proportion = 0.5;
          gaps = 10;
          border = {
            enable = true;
            width = 2;
            active.color = colorCfg.lightBlack;
            inactive.color = colorCfg.lightBlack;
            urgent.color = colorCfg.lightBlack;
          };
          focus-ring =
            let
              gradient = {
                from = colorCfg.lightBlue;
                to = colorCfg.lightCyan;
                angle = 180;
                relative-to = "workspace-view";
              };
            in
            {
              enable = true;
              width = 5;
              active.gradient = gradient;
              inactive.gradient = gradient;
              urgent.gradient = gradient;
            };
          shadow.enable = false;
          background-color = "transparent";
        };
        animations = {
          window-open.kind.easing = {
            curve = "ease-out-cubic";
            duration-ms = 500;
          };
          window-close.kind.easing = {
            curve = "ease-out-expo";
            duration-ms = 700;
          };
          window-movement.kind.spring = {
            damping-ratio = 0.8;
            stiffness = 200;
            epsilon = 0.001;
          };
        };
        window-rules = [
          {
            clip-to-geometry = true;
            geometry-corner-radius = {
              bottom-left = 20.0;
              bottom-right = 20.0;
              top-left = 20.0;
              top-right = 20.0;
            };
          }
        ];
        prefer-no-csd = true;
        layer-rules =
          [ ]
          ++ lib.optionals hasWallpaper [
            {
              matches = [
                { namespace = "^swww"; }
              ];
              place-within-backdrop = true;
            }
          ];
        spawn-at-startup = [
          { command = [ "${lib.getExe pkgs.tsssni-shell}" ]; }
        ]
        ++ lib.optionals (imeCfg.enable && (imeCfg.type == "fcitx5")) [
          { command = [ "${lib.getExe pkgs.fcitx5}" ]; }
        ]
        ++ lib.optionals hasWallpaper lib.mapAttrsToList (monitor: value: {
            command = [ "swww img ${value.wallpaper} -o ${monitor}" ];
        }) cfg.monitors;
        binds = with config.lib.niri.actions; {
          "Mod+T".action.spawn = [
            "ghostty"
          ]
          ++ lib.optionals shellCfg.enable [
            "-e"
            "${lib.getExe zellijCfg.package}"
          ];
          "Mod+B".action.spawn = [ "firefox" ];
          "Mod+Q".action.quit.skip-confirmation = true;
          "Mod+P".action.screenshot.show-pointer = false;
          "Mod+W".action.screenshot-window.write-to-disk = true;
          "Mod+O".action = toggle-overview;
          "Mod+M".action = maximize-column;
          "Mod+F".action = fullscreen-window;
          "Mod+X".action = close-window;
          "Mod+Z".action.spawn-sh = [ "${lib.getExe pkgs.tsssni-shell} ipc call toggleBlurryPlayer toggle" ];

          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+J".action = focus-window-down;
          "Mod+K".action = focus-window-up;
          "Mod+Down".action = focus-workspace-down;
          "Mod+Up".action = focus-workspace-up;

          "Mod+Ctrl+H".action = move-column-left;
          "Mod+Ctrl+L".action = move-column-right;
          "Mod+Ctrl+J".action = move-window-down;
          "Mod+Ctrl+K".action = move-window-up;
          "Mod+Ctrl+X".action = center-column;
          "Mod+Ctrl+I".action = consume-or-expel-window-left;
          "Mod+Ctrl+O".action = consume-or-expel-window-right;
          "Mod+Ctrl+Down".action = move-window-to-workspace-down;
          "Mod+Ctrl+Up".action = move-window-to-workspace-up;

          "Mod+Alt+H".action = switch-preset-column-width;
          "Mod+Alt+L".action = maximize-column;
          "Mod+Alt+J".action = switch-preset-window-height;
          "Mod+Alt+K".action = reset-window-height;

          "Mod+WheelScrollUp".action = focus-column-left;
          "Mod+WheelScrollDown".action = focus-column-right;
        };
      }
      // cfg.extraSettings;
    };

    services = {
      swww.enable = hasWallpaper;
      wlsunset = {
        inherit (cfg.sunset) enable temperature;
      }
      // cfg.sunset.coordinate;
    };

    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
