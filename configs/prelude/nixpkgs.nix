{
  lib,
  tsssni,
  ...
}:
{
  nixpkgs = {
    system = tsssni.system;
    config = {
      allowUnfree = true;
    }
    // lib.optionalAttrs (tsssni.distro == "nixos") {
      cudaSupport = tsssni.cuda;
      rocmSupport = tsssni.rocm;
    };
    overlays =
      with tsssni.inputs;
      (
        [
          (final: prev: {
            agenix = agenix.packages.${tsssni.system}.default;
          })
        ]
        ++ (import ../../pkgs lib)
      );
  };
}
