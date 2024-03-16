{ config, pkgs, ... }:
{
	imports = [ ./hyprland ];
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;
}
