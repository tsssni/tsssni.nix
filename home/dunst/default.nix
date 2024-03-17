{ pkgs, ... }:
{
	services.dunst = {
		enable = true;
		settings = {
			global = {
				monitor = 0;
				follow = "none";
				width = 300;
				height = 300;
				origin = "top-right";
				offset = "10x50";
				scale = 0;
				notification_limit = 20;
				progress_bar = true;
				progress_bar_height = 10;
				progress_bar_frame_width = 0;
				progress_bar_min_width = 150;
				progress_bar_max_width = 300;
				progress_bar_corner_radius = 10;
				icon_corner_radius = 10;
				indicate_hidden = "yes";
				transparency = 100;
				separator_height = 0;
				padding = 8;
				horizontal_padding = 8;
				text_icon_padding = 0;
				frame_width = 0;
				frame_color = "#000000";
				gap_size = 5;
				separator_color = "frame";
				sort = "yes";
				font = "MonaspiceNe NFM 10";
				line_height = 0;
				markup = "full";
				format = "<b>%a</b> %p\n%b";
				alignment = "left";
				vertical_alignment = "center";
				show_age_threshold = "60";
				ellipsize = "middle";
				ignore_newline = "no";
				stack_duplicates = "true";
				hide_duplicate_count = false;
				show_indicators = "yes";
				enable_recursive_icon_lookup = "true";
				icon_theme = "Fluent";
				icon_position = "left";
				min_icon_size = 32;
				max_icon_size = 128;
				sticky_history = "yes";
				history_length = "20";
				dmenu = "dmenu -p dunst";
				browser = "xdg-open";
				always_run_script = true;
				title = "Dunst";
				class = "Dunst";
				corner_radius = 10;
				ignore_dbuscluse = false;
				force_xwayland = false;
				force_xinerama = false;
				mouse_left_click = "do_action, close_current";
				mouse_middle_click = "close_all";
				mouse_right_click = "close_current";
			};

			experimental.per_monitor_dpi = false;

			urgency_low = {
				background = "#1a0b63c8";
				foreground = "#ece0ff99";
				highlight = "#ece0ff99";
				timeout = 10;
			};

			urgency_normal = {
				background = "#f5c1e999";
				foreground = "#ff005599";
				highlight = "#ff005599";
				timeout = 10;
			};

			urgency_critical = {
				background = "#ff005599";
				foreground = "#ffff0099";
				highlight = "#ffff0099";
				timeout = 0;
			};
		};
	};	
}
