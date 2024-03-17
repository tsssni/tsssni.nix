{ pkgs, ... }:
{
	home.packages = with pkgs; [
		polkit
		polkit_gnome

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
