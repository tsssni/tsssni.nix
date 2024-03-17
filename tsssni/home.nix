{ config, pkgs, ... }:
{
	imports = [ 
		./hyprland
		./kitty
		./rofi
		./dunst
		./theme.nix
		./misc.nix
	];
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		packages = with pkgs; [
			swww

			polkit
			polkit_gnome

			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			(nerdfonts.override { fonts = [ "Monaspace" ]; })

			dconf
			dmenu
			xdg-utils
			xdg-user-dirs
		];
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;
}
