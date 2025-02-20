{ ... }:
{
	home = {
		username = "tsssni";
		homeDirectory = "/Users/tsssni";
		stateVersion = "24.11";
	};

	programs.home-manager.enable = true;

	imports = [
		./devel
		./nixvim
		./shell
		./visual
		./vscode
		./wired
	];
}
