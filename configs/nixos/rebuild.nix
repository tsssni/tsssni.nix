args:
import ../rebuild.nix (args
  // { 
    root = "nixos";
    rebuildFunc = args.inputs.nixpkgs.lib.nixosSystem;
    tsssni = args.tsssni // {
      systemModule = args.tsssni.nixosModules.tsssni;
    };
    inputs = args.inputs // {
      home-manager = args.inputs.home-manager  // {
        systemModule = args.inputs.home-manager.nixosModules.home-manager;
      };
    };
  })
