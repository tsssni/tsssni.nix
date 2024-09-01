{ ags, nixvim, ... }:
{
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "24.05";
	};

	programs.home-manager.enable = true;

	imports = [ 
    ags.homeManagerModules.default
    nixvim.homeManagerModules.nixvim
		./devel
    ./nixvim
    ./shell
    ./visual
    ./wired
	];
}
