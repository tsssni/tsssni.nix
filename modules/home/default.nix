{
  lib,
  ...
}:
{
  imports = lib.importDir ./.;

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
