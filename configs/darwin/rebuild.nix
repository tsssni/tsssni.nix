args:
import ../rebuild.nix (
  args
  // {
    distro = "darwin";
    eval = args.inputs.nix-darwin.lib.darwinSystem;
    tsssni = args.tsssni // {
      systemModules = args.tsssni.darwinModules.tsssni;
      extraSystemModules = args.tsssni.extraDarwinModules;
    };
    inputs = args.inputs // {
      home-manager = args.inputs.home-manager // {
        systemModules = args.inputs.home-manager.darwinModules.home-manager;
      };
    };
  }
)
