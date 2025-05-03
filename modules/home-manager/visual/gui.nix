{
  lib
, pkgs
, config
, ...
}:
let
	cfg = config.tsssni.visual.gui;
in {
	options.tsssni.visual.gui = {
		enable = lib.mkEnableOption "tsssni.visual.gui";
	};

	config = lib.mkIf cfg.enable {
		home = {
			packages = with pkgs; [
				dconf
			];

			pointerCursor = {
				gtk.enable = true;
				package = pkgs.apple-cursor;
				name = "macOS";
				size = 24;
			};
		};

		gtk = {
			enable = true;

			theme = {
				name = "Fluent";
				package = pkgs.fluent-gtk-theme;
			};

			iconTheme = {
				name = "Fluent";
				package = pkgs.fluent-icon-theme;
			};

			font = config.tsssni.visual.font.latinFont;

			gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
			gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
			gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
		};

		qt = {
			enable = true;
			platformTheme.name = "gtk";
		};
	};
}
