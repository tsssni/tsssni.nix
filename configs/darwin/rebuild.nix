args:
import ../rebuild.nix (
  args
  // {
    distro = "darwin";
    eval = args.inputs.nix-darwin.lib.darwinSystem;
  }
)
