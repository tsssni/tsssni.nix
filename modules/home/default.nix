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
    };
  };
}
