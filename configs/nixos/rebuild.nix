args:
import ../rebuild.nix (
  args
  // {
    distro = "nixos";
    eval = args.inputs.nixpkgs.lib.nixosSystem;
  }
)
