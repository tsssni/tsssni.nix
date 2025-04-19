{ ... }:
{
	home = {
		username = "wsl";
		homeDirectory = "/home/wsl";
		stateVersion = "24.11";
	};

	programs.home-manager.enable = true;

	imports = [
		./devel
		./nixvim
		./shell
		./wired
	];
}
