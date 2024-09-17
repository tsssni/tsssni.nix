{ ... }:
{
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "24.05";
	};

	programs.home-manager.enable = true;

	imports = [ 
		./devel
    ./shell
    ./visual
    ./wired
    ../../../nixvim
	];
}
