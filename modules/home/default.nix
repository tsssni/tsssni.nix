{
  lib,
  config,
  ...
}:
{
  imports = lib.importDir ./. ++ [ ../universal ];

  options.tsssni.home = {
    standalone = lib.mkOption {
      description = "Standalone Home Manager configuration.";
      type = lib.types.bool;
      default = false;
    };
    install = lib.mkOption {
      description = "Conditional package installation helper.";
      type = lib.types.functionTo (lib.types.nullOr lib.types.package);
      readOnly = true;
      default = pkg: if config.tsssni.home.standalone then null else pkg;
    };
  };
}
