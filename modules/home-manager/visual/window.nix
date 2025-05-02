{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.visual.window;
in  {
	options.tsssni.visual.window = {
		enable = lib.mkEnableOption "tsssni.visual.window";
		monitors = lib.mkOption {
			type = with lib.types; listOf str;
			default = [];
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
			type = with lib.types; path;
			default = null;
			description = ''
				window manager wallpaper
			'';
			example = lib.literalExpression ''
				.config/hypr/wallpaper/plana.jpeg
			'';
		};
		extraSettings = lib.mkOption {
			type = with lib.types;
			let
				valueType = nullOr (oneOf [
					bool
					int
					float
					str
					path
					(attrsOf valueType)
					(listOf valueType)
				]) // {
					description = "Hyprland configuration value";
				};
			in valueType;
			default = {};
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
				hyprscroller
			];
			systemd.enable = false;
			settings = {
				monitor = cfg.monitors;
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
						layout = "scroller";
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
				dwindle =  {
						pseudotile = true;
						preserve_split = true;
				};
				plugin.scroller = {
					column_default_width = "onehalf";
					window_default_height = "one";
					column_widths = "onethird onehalf twothirds";
					window_heights = "onethird onehalf twothirds one";
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

					"SUPER, H, scroller:movefocus, l"
					"SUPER, L, scroller:movefocus, r"
					"SUPER, J, scroller:movefocus, d"
					"SUPER, K, scroller:movefocus, u"

					"SUPERCTRL, H, scroller:movewindow, l"
					"SUPERCTRL, L, scroller:movewindow, r"
					"SUPERCTRL, J, scroller:movewindow, d"
					"SUPERCTRL, K, scroller:movewindow, u"
					"SUPERCTRL, I, scroller:movewindow, b"
					"SUPERCTRL, O, scroller:movewindow, e"
					"SUPERCTRL, Z, scroller:alignwindow, l"
					"SUPERCTRL, X, scroller:alignwindow, c"
					"SUPERCTRL, C, scroller:alignwindow, r"
					"SUPERCTRL, V, scroller:alignwindow, u"
					"SUPERCTRL, B, scroller:alignwindow, d"

					"SUPERALT, J, scroller:setmode, row"
					"SUPERALT, K, scroller:setmode, col"
					"SUPERALT, H, scroller:cyclesize, prev"
					"SUPERALT, L, scroller:cyclesize, next"
					"SUPERALT, I, scroller:admitwindow"
					"SUPERALT, O, scroller:expelwindow"

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
				exec-once = [
					# wallpaper
					"swww init; swww img ${cfg.wallpaper} --transition-type none"
					"ags"
					"fcitx5 -d -r"
				];
			} // cfg.extraSettings;
		};

		home = {
			file.".tsssnirc" = {
				source = ./config/.tsssnirc;
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
