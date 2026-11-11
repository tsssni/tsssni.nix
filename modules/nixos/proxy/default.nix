{
  lib,
  ...
}:
{
  imports = lib.importDir ./.;

  options.tsssni.proxy = {
    enable = lib.mkEnableOption "proxy server services";
    domain = lib.mkOption {
      description = "Proxy server domain.";
      type = lib.types.str;
    };
    email = lib.mkOption {
      description = "ACME contact email.";
      type = lib.types.str;
    };
    hostName = lib.mkOption {
      description = "Server hostname.";
      type = lib.types.str;
    };
    address = lib.mkOption {
      description = "Interface IP addresses.";
      type = lib.types.listOf lib.types.str;
    };
    gateway = lib.mkOption {
      description = "Default gateway addresses.";
      type = lib.types.listOf lib.types.str;
    };
    passwd = lib.mkOption {
      description = "Encrypted proxy password file.";
      type = lib.types.path;
    };
    cloudflareApiToken = lib.mkOption {
      description = "Encrypted Cloudflare token file.";
      type = lib.types.path;
    };
  };
}
