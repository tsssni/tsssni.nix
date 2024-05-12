{ inputs, ... }:
{
	home = {
		username = "tsssni";
		homeDirectory = "/home/tsssni";
		stateVersion = "23.11";
	};

	programs.home-manager.enable = true;

	imports = [ 
    inputs.hyprland.homeManagerModules.default
    inputs.ags.homeManagerModules.default
		./devel
    ./shell
    ./visual
    ./wired
	];
}
