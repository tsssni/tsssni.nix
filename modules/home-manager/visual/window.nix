{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.window;
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
      type = settingsType;
      default = { };
      description = ''
        window manager monitors
      '';
      example = lib.literalExpression ''
        {
          "eDP-1".scale = 2.0;
        }
      '';
    };
    wallpaper = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        window manager wallpaper
      '';
      example = lib.literalExpression ''
        .config/hypr/wallpaper/plana.jpeg
      '';
    };
    nvidia = lib.mkOption {
      type = with lib.types; bool;
      default = false;
      description = ''
        use nvidia-settings for window manager
      '';
      example = false;
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
      settings = {
        input = {
          keyboard.xkb = {
            layout = "us";
            options = "caps:ctrl_modifier";
          };
          focus-follows-mouse.enable = true;
        };
        outputs = cfg.monitors;
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
          border =
            let
              color = "#645e8c";
            in
            {
              enable = true;
              width = 2;
              active.color = color;
              inactive.color = color;
              urgent.color = color;
            };
          focus-ring =
            let
              gradient = {
                from = "#a0b4e5";
                to = "#9fe5e5";
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
          ++ lib.optionals (config.tsssni.visual.window.wallpaper != null) [
            {
              matches = [
                { namespace = "^swww-daemon$"; }
              ];
              place-within-backdrop = true;
            }
          ];
        spawn-at-startup =
          [ ]
          ++ lib.optionals (config.tsssni.visual.window.wallpaper != null) [
            { command = [ "swww-daemon" ]; }
            { command = [ "swww img ${cfg.wallpaper} --transition-type none" ]; }
          ]
          ++ lib.optionals config.tsssni.visual.widget.enable [
            { command = [ "tsssni-astal" ]; }
          ]
          ++ lib.optionals config.tsssni.visual.ime.enable [
            { command = [ "fcitx5" ]; }
          ];
        binds = with config.lib.niri.actions; {
          "Mod+T".action = spawn "kitty";
          "Mod+B".action = spawn "firefox";
          "Mod+X".action = close-window;
          "Mod+Q".action.quit.skip-confirmation = true;
          "Mod+P".action.screenshot.show-pointer = false;
          "Mod+W".action.screenshot-window.write-to-disk = true;
          "Mod+O".action = toggle-overview;
          "Mod+M".action = maximize-column;
          "Mod+F".action = toggle-windowed-fullscreen;
          "Mod+V".action = toggle-window-floating;

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
      } // cfg.extraSettings;
    };

    home = {
      file.".tsssnirc" = {
        text = lib.strings.trim ''
          #!/usr/bin/env nu
          sudo chmod 444 /sys/class/powercap/intel-rapl:0/energy_uj;
          openrgb -p tsssni
          niri
        '';
        executable = true;
      };
      packages = with pkgs; [
        swww
        wl-clipboard
      ];
    };
  };
}
