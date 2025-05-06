{ ... }:
{
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "24.11";
	};

	programs.home-manager.enable = true;

	imports = [
		./aesth.nix
		./devel.nix
		./nixvim.nix
		./shell.nix
		./visual.nix
		./wired.nix
	];
}
