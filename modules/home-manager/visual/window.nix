{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.window;
in
{
  options.tsssni.visual.window = {
    enable = lib.mkEnableOption "tsssni.visual.window";
    monitors = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        window manager monitors
      '';
      example = lib.literalExpression ''
        [
        	", preferred, 0x0, 1"
        ]
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
      type =
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
              description = "Hyprland configuration value";
            };
        in
        valueType;
      default = { };
      description = ''
        	Hyprland configuration written in Nix. Entries with the same key
        	should be written as lists. Variables' and colors' names should be
        	quoted. See <https://wiki.hyprland.org> for more examples.

        	::: {.note}
        	Use the [](#opt-wayland.windowManager.hyprland.plugins) option to
        	declare plugins.
        	:::

      '';
      example = lib.literalExpression ''
        {
          decoration = {
            shadow_offset = "0 5";
            "col.shadow" = "rgba(00000099)";
          };

          "$mod" = "SUPER";

          bindm = [
            # mouse movements
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      plugins = with pkgs.hyprlandPlugins; [
        hyprscrolling
      ];
      systemd.enable = false;
      settings = {
        monitor = cfg.monitors;
        xwayland.force_zero_scaling = true;
        cursor = {
          no_hardware_cursors = true;
          no_warps = true;
        };
        input = {
          kb_layout = "us";
          kb_options = "caps:ctrl_modifier";
          follow_mouse = 1;
          sensitivity = 0;
        };
        general = {
          gaps_in = 10;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(f5c1e9ff)";
          "col.inactive_border" = "rgba(f5c1e9ff)";
          layout = "scrolling";
        };
        decoration = {
          rounding = 20;

          blur = {
            enabled = true;
            size = 3;
            passes = 4;
            ignore_opacity = true;
          };

          shadow = {
            enabled = true;
            range = 10;
            render_power = 3;
            color = "rgba(f5c1e9ff)";
            color_inactive = "rgba(f5c1e9ff)";
          };
        };
        animations = {
          enabled = true;

          bezier = [
            "open, 0.66, 0.88, 0.2, 0.96"
            "move, 0.18, 1.2, 0.68, 1"
            "close, 0.03, 0.45, 0, 0.97"
            "fade, 0.19, 0.02, 0.44, 0.15"
          ];

          animation = [
            "windowsIn, 1, 7, open"
            "windowsOut, 1, 7, close"
            "windowsMove, 1, 7, move"
            "fade, 1, 3, fade"
            "workspaces, 1, 7, move"
          ];
        };
        plugin.hyprscrolling = {
          column_width = 0.5;
          explicit_column_widths = "0.333, 0.5, 0.667";
          focus_fit_method = 1;
        };
        dwindle = {
          force_split = 2;
        };
        windowrulev2 = [
          # "noblur, class:^(?!kitty).*$"
          "opacity 0.8 0.7 1.0, class:^(kitty)$"
        ];
        layerrule = [
          "blur, gtk-layer-shell"
          "ignorezero, gtk-layer-shell"
        ];
        bind = [
          "SUPER, T, exec, kitty"
          "SUPER, X, killactive"
          "SUPER, Q, exit"
          "SUPER, V, togglefloating"
          "SUPER, B, exec, firefox"
          "SUPER, O, exec, hyprctl setprop active opaque toggle"
          "SUPER, P, pseudo"
          "SUPER, S, togglesplit"
          "SUPER, G, togglegroup"
          "SUPER, N, changegroupactive, f"
          "SUPER, R, exec, grim -g \"$(slurp)\""

          "SUPER, H, layoutmsg, move -col"
          "SUPER, L, layoutmsg, move +col"
          "SUPERCTRL, H, swapwindow, l"
          "SUPERCTRL, L, swapwindow, r"
          "SUPERALT, H, layoutmsg, colresize -conf"
          "SUPERALT, L, layoutmsg, colresize +conf"

          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"

          "SUPERSHIFT, 1, movetoworkspace, 1"
          "SUPERSHIFT, 2, movetoworkspace, 2"
          "SUPERSHIFT, 3, movetoworkspace, 3"
          "SUPERSHIFT, 4, movetoworkspace, 4"
          "SUPERSHIFT, 5, movetoworkspace, 5"
        ];
        exec-once =
          [ ]
          ++ lib.optionals (config.tsssni.visual.window.wallpaper != null) [
            "swww img ${cfg.wallpaper}"
          ]
          ++ lib.optionals config.tsssni.visual.widget.enable [
            "tsssni-astal"
          ]
          ++ lib.optionals config.tsssni.visual.ime.enable [
            "fcitx5 -d -r"
          ];
      } // cfg.extraSettings;
    };

    home = {
      file.".tsssnirc" = {
        text = lib.strings.trim ''
          #!/usr/bin/env nu
          sudo chmod 444 /sys/class/powercap/intel-rapl:0/energy_uj;
          openrgb -p tsssni
          Hyprland
        '';
        executable = true;
      };
      packages = with pkgs; [
        swww
        grim
        slurp
        hyprsunset
        wl-clipboard
      ];
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [ "hyprland" ];
      };
    };
  };
}
