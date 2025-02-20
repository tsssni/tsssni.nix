args:
import ../rebuild.nix (args
// { 
	distro = "nix-darwin";
	eval = args.inputs.nix-darwin.lib.darwinSystem;
	tsssni = args.tsssni // {
		systemModules = args.tsssni.darwinModules.tsssni;
	};
	inputs = args.inputs // {
		home-manager = args.inputs.home-manager  // {
			systemModules = args.inputs.home-manager.darwinModules.home-manager;
		};
	};
})
