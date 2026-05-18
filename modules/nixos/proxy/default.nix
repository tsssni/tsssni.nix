{
  lib,
  ...
}:
{
  imports = lib.importDir ./.;

  options.tsssni.proxy = {
    enable = lib.mkEnableOption "tsssni.proxy";
    domain = lib.mkOption {
      type = lib.types.str;
    };
    email = lib.mkOption {
      type = lib.types.str;
    };
    hostName = lib.mkOption {
      type = lib.types.str;
    };
    address = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
    gateway = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
    passwd = lib.mkOption {
      type = lib.types.path;
    };
    cloudflareApiToken = lib.mkOption {
      type = lib.types.path;
    };
  };
}
