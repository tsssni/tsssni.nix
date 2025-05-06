{ ... }:
{
	home = {
		username = "deck";
		homeDirectory = "/home/deck";
		stateVersion = "24.11";
	};

	programs.home-manager.enable = true;

	imports = [
		./devel.nix
		./nixvim.nix
		./shell.nix
		./wired.nix
	];
}
