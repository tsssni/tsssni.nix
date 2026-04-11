args:
import ../rebuild.nix (
  args
  // {
    distro = "nixos";
    eval = args.inputs.nixpkgs.lib.nixosSystem;
    modules = args.modules // { system = args.modules.nixos; };
  }
)
