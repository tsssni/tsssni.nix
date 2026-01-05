{
  pkgs,
  config,
  ...
}:
let
  domain = "tsssni.top";
in
{
  age.secrets."sbx-cloudflare" = {
    file = ./config/sbx-cloudflare.age;
    group = "acme";
    mode = "0440";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "dingyongyu2002@foxmail.com";
    certs."${domain}" = {
      webroot = null;
      dnsProvider = "cloudflare";
      environmentFile = "${pkgs.writeText "cf-creds" ''
        CF_DNS_API_TOKEN_FILE = ${config.age.secrets."sbx-cloudflare".path}
      ''}";
      group = "nginx";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/".root = "/var/www";
          "/.well-known/acme-challenge/".alias = "/var/lib/acme/.challenges/.well-known/acme-challenge/";
        };
      };
      "acmechallenge.${domain}".locations = {
        "/.well-known/acme-challenge".root = "/var/lib/acme/.challenges";
        "/".return = "301 https://$host$request_uri";
      };
    };
  };
}
