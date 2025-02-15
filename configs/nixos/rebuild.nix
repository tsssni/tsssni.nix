args:
import ../rebuild.nix (args
  // { 
    distro = "nixos";
    eval = args.inputs.nixpkgs.lib.nixosSystem;
    tsssni = args.tsssni // {
      systemModules = args.tsssni.nixosModules.tsssni;
    };
    inputs = args.inputs // {
      home-manager = args.inputs.home-manager  // {
        systemModules = args.inputs.home-manager.nixosModules.home-manager;
      };
    };
  })
