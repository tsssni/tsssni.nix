args:
import ../rebuild.nix (
  args
  // {
    distro = "darwin";
    eval = args.inputs.nix-darwin.lib.darwinSystem;
    modules = args.modules // { system = args.modules.darwin; };
  }
)
