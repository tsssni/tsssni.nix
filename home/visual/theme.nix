{ pkgs, ... }:
{
	home = {
    packages = with pkgs; [
      # fonts
			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			(nerdfonts.override { fonts = [ "Monaspace" ]; })
      # for gtk
      dconf
    ];

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS-BigSur";
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

		font.name = "MonaspiceNe Nerd Font Medium 12";

		gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
		gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
		gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
	};

	qt = {
		enable = true;
	};
}
