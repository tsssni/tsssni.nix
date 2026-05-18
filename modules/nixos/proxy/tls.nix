{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.tsssni.proxy;
  secret = key: config.age.secrets."proxy-${key}".path;
in
{
  config = lib.mkIf cfg.enable {
    age.secrets."proxy-cloudflare" = {
      file = cfg.cloudflareApiToken;
      group = "acme";
      mode = "0440";
    };

    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;
      certs.${cfg.domain} = {
        webroot = null;
        dnsProvider = "cloudflare";
        environmentFile = "${pkgs.writeText "cf-creds" ''
          CF_DNS_API_TOKEN_FILE = ${secret "cloudflare"}
        ''}";
        group = "nginx";
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/".root = "/var/www";
      };
    };
  };
}
