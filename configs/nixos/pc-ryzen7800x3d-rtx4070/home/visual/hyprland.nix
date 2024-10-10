{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd.enable = false;
    settings = {
      monitor = [
        "desc:Philips Consumer Electronics Company PHL24M1N5500Z UK82338003590, highrr, 0x0, 1.25"
        "Unknown-1, disable"
      ];
      cursor.no_hardware_cursors = true;
      xwayland.force_zero_scaling = true;
      input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
      };
      general = {
          gaps_in = 10;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(f5c1e9ff)";
          "col.inactive_border" = "rgba(f5c1e9ff)";
          layout = "dwindle";
      };
      decoration = {
          rounding = 20;

          active_opacity = 0.8;
          inactive_opacity = 0.7;
          fullscreen_opacity = 1.0;
          
          blur = {
              enabled = true;
              size = 3;
              passes = 4;
              ignore_opacity = true;
          };

          drop_shadow = true;
          shadow_range = 10;
          shadow_render_power = 3;
          "col.shadow" = "rgba(f5c1e9ff)";
          "col.shadow_inactive" = "rgba(f5c1e9ff)";
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
      dwindle =  {
          pseudotile = true;
          preserve_split = true;
      };
      windowrulev2 = [
        "noblur, class:^(firefox)$"
        "opacity 1.0 override, class:^(firefox)$"
      ];
      bind = [
        "SUPER, T, exec, kitty"
        "SUPER, X, killactive"
        "SUPER, Q, exit"
        "SUPER, V, togglefloating"
        "SUPER, B, exec, firefox"
        "SUPER, F, fullscreen, 0"
        "SUPER, M, fullscreen, 1"
        "SUPER, O, exec, hyprctl setprop active opaque toggle"
        "SUPER, P, pseudo"
        "SUPER, S, togglesplit"
        "SUPER, G, togglegroup"
        "SUPER, N, changegroupactive, f"
        "SUPER, R, exec, grim -g \"$(slurp)\""

        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"

        "SUPERCTRL, H, movewindow, l"
        "SUPERCTRL, L, movewindow, r"
        "SUPERCTRL, J, movewindow, d"
        "SUPERCTRL, K, movewindow, u"

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
      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,macOS"
        "QT_QPA_PLATFORMTHEME,qt5ct"

        # gpu
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      exec-once = [
        # wallpaper
        "swww init; swww img ~/.config/hypr/wallpaper/plana.jpeg --transition-type none"
        "ags"
      ];
    };
  };

  home = {
    packages = with pkgs; [ 
      swww
      grim
      slurp
    ];

    file.".config/hypr/wallpaper" = {
      source = ./config/hypr/wallpaper;
      recursive = true;
    };
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
}
