args:
import ../rebuild.nix (args
  // { 
    root = "nix-darwin";
    rebuildFunc = args.inputs.nix-darwin.lib.darwinSystem;
    tsssni = args.tsssni // {
      systemModule = args.tsssni.darwinModules.tsssni;
    };
    inputs = args.inputs // {
      home-manager = args.inputs.home-manager  // {
        systemModule = args.inputs.home-manager.darwinModules.home-manager;
      };
    };
  })
