{
  pkgs,
  lib,
  tsssni,
  ...
}:
{
  nix =
    let
      features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
      ];
      keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    in
    {
      package = pkgs.nix;
      nixPath = [
        "nixpkgs=${tsssni.inputs.nixpkgs}"
      ];
      settings = {
        experimental-features = features;
        substituters = substituters;
        trusted-substituters = substituters;
        trusted-public-keys = keys;
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
