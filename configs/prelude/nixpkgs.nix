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
    // lib.optionalAttrs (tsssni.distro == "nixos") tsssni.config;
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
