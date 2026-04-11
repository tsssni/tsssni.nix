args:
import ../rebuild.nix (
  args
  // {
    distro = "home";
    eval = args.inputs.home-manager.lib.homeManagerConfiguration;
  }
)
