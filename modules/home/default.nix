{ lib, ... }:
let
  lib' = import ../../lib { inherit lib; };
in
{
  imports = lib'.importDir ./.;

  options.tsssni.home = {
    standalone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        standalone home-manager prefer user to install packages with system package manager
      '';
    };
  };
}
