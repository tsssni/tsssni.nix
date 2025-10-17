{
  pkgs,
  lib,
  tsssni,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    nixPath = [
      "nixpkgs=${tsssni.inputs.nixpkgs}"
    ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
      ];
      trusted-substituters = [
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  }
  // lib.optionalAttrs (tsssni.distro != "home") {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      persistent = true;
      dates = "Tue 04:00";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      interval = {
        Weekday = 2;
        Hour = 4;
        Minute = 0;
      };
    };
    optimise.automatic = true;
  };
}
// (
  let
    packages = with pkgs; [
      nix
      nh
    ];
  in
  if (tsssni.distro != "home") then
    {
      environment.systemPackages = packages;
    }
  else
    {
      home.packages = packages;
    }
)
