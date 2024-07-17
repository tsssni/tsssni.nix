{ inputs, ... }:
{
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;

	imports = [ 
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
		./devel
    ./nixvim
    ./shell
    ./visual
    ./wired
	];
}
