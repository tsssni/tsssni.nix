{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nix.nix;
in
{
  options.tsssni.nix.nix = {
    enable = lib.mkEnableOption "tsssni.nix.nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        substituters = [
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
      gc =
        { }
        // {
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
  };
}
