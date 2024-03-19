{ config, pkgs, ... }:
{
	imports = [ 
		./nvim
		./bash
		./kitty
		./git
		./eww
		./hyprland
		./rofi
		./dunst
		./fcitx5
		./browser.nix
		./theme.nix
	];
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		packages = with pkgs; [
			# programming
			python3
      # shell
			blesh
      neofetch
      # terminal
      kitty
      # wm
      hyprland
			# wallpaper
			swww
			# bar
			eww
      # launcher
      rofi-wayland
      # notification
      dunst
      # screenshot
      grim
      slurp
			# media
			playerctl
			imagemagick
			# volume
			wireplumber
			# brightness
			brightnessctl
			# bluetooth
			bluez
			# polkit
			polkit
			polkit_gnome
			# font
			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			(nerdfonts.override { fonts = [ "Monaspace" ]; })
			# misc
			dconf
			dmenu
			xdg-utils
			xdg-user-dirs
      ripgrep
		];
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;
}
