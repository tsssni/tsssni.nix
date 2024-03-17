{ pkgs, ... }: {
	wayland.windowManager.hyprland = {
		enable = true;

		settings = {
			xwayland = {
				force_zero_scaling = true;
			};

			monitor = [ ", highrr, 0x0, 1.25" ];
			
			input = {
				kb_layout = "us";
				kb_variant = "";
				kb_model = "";
				kb_options = "";
				kb_rules = "";

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
				
				active_opacity = "0.8";
				inactive_opacity = "0.7";
				fullscreen_opacity = "1.0";

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

			dwindle = {
				pseudotile = true;
				preserve_split = true;
			};

			master = {
				new_is_master = false;
			};

			"$main_mod" = "SUPER";

			bind = [
				"$main_mod, T, exec, kitty"
				"$main_mod, K, killactive"
				"$main_mod, Q, exit"
				"$main_mod, F, exec, index"
				"$main_mod, V, togglefloating"
				"$main_mod, A, exec, rofi -show drun"
				"$main_mod, H, fullscreen, 0"
				"$main_mod, M, fullscreen, 1"
				"$main_mod, O, toggleopaque"
				"$main_mod, P, pseudo" #dwindle
				"$main_mod, S, togglesplit" #dwindle
				"$main_mod, G, togglegroup" #dwindle
				"$main_mod, N, changegroupactive, f" #dwindle
				"$main_mod, R, exec, grim -g \"$(slurp)\""

				"$main_mod, left, movefocus, l"
				"$main_mod, right, movefocus, r"
				"$main_mod, up, movefocus, u"
				"$main_mod, down, movefocus, d"

				"$main_mod CTRL, left, movewindow, l"
				"$main_mod CTRL, right, movewindow, r"
				"$main_mod CTRL, up, movewindow, u"
				"$main_mod CTRL, down, movewindow, d"

				"$main_mod, 1, workspace, 1"
				"$main_mod, 2, workspace, 2"
				"$main_mod, 3, workspace, 3"
				"$main_mod, 4, workspace, 4"
				"$main_mod, 5, workspace, 5"
				"$main_mod, 6, workspace, 6"
				"$main_mod, 7, workspace, 7"
				"$main_mod, 8, workspace, 8"
				"$main_mod, 9, workspace, 9"
				"$main_mod, 0, workspace, 10"

				"$main_mod SHIFT, 1, movetoworkspace, 1"
				"$main_mod SHIFT, 2, movetoworkspace, 2"
				"$main_mod SHIFT, 3, movetoworkspace, 3"
				"$main_mod SHIFT, 4, movetoworkspace, 4"
				"$main_mod SHIFT, 5, movetoworkspace, 5"
				"$main_mod SHIFT, 6, movetoworkspace, 6"
				"$main_mod SHIFT, 7, movetoworkspace, 7"
				"$main_mod SHIFT, 8, movetoworkspace, 8"
				"$main_mod SHIFT, 9, movetoworkspace, 9"
				"$main_mod SHIFT, 0, movetoworkspace, 10"

				"$main_mod, mouse_down, workspace, e+1"
				"$main_mod, mouse_up, workspace, e-1"
			];

			bindm = [
				"$main_mod, mouse:272, movewindow"
				"$main_mod, mouse:273, resizewindow"
			];

			env = [
				"QT_QPA_PLATFORMTHEME,qt5ct"
				"LIBVA_DRIVER_NAME,nvidia"
				"XDG_SESSION_TYPE,wayland"
				"XCURSOR_SIZE,24"
				"QT_QPA_PLATFORMTHEME,gtk"
				"GBM_BACKEND,nvidia-drm"
				"__GLX_VENDOR_LIBRARY_NAME,nvidia"
				"WLR_NO_HARDWARE_CURSORS,1"	
			];

			exec-once = [
				"swww init; swww img ${./wallpaper/plana.jpeg} --transition-type once"
				# "eww -c ~/.config/eww open dashboard"
				"${pkgs.polkit_gnome}/libexec/polkit-gnome/polkit-gnome-authentication-agent-1"
				# "fcitx5"
			];

			layerrule = [
				# "blur, gtk-layer-shell"
				# "ignorezero, gtk-layer-shell"
				"blur, rofi"
				"ignorezero, rofi"
				"blur, notification"
				"ignorezero, notification"
			];
		};
	};
}
