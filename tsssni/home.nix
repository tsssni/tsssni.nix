{ config, pkgs, ... }:
{
	imports = [ 
		./hyprland
		./kitty
	];
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;
}
