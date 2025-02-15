args:
import ../rebuild.nix (args
  // { 
    distro = "home-manager";
    eval = args.inputs.home-manager.lib.homeManagerConfiguration;
    tsssni = args.tsssni;
    inputs = args.inputs;
  })
