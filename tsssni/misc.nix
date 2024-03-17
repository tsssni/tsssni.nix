{ pkgs, ... }:
{
	home.packages = with pkgs; [
		polkit
		polkit_gnome

		xdg-utils
		xdg-user-dirs

		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		(nerdfonts.override { fonts = [ "Monaspace" ]; })
	];

	programs = {
		chromium = {
			enable = true;
			package = pkgs.google-chrome;
			commandLineArgs = [ 
				"--enable-features=UseOzonePlatform"
				"--ozone-platform=wayland" 
				"--enable-wayland-ime" 
			];
		};
	};
}
