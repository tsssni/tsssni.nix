{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.proxy;
  cert_dir = "/var/lib/acme/${cfg.domain}";
  tls = {
    enabled = true;
    server_name = cfg.domain;
    certificate_path = "${cert_dir}/fullchain.pem";
    key_path = "${cert_dir}/key.pem";
  };
  users = [
    {
      name = "hime";
      password._secret = config.age.secrets."proxy-passwd".path;
    }
  ];
in
{
  config = lib.mkIf cfg.enable {
    age.secrets."proxy-passwd".file = cfg.passwd;
    services.sing-box = {
      enable = true;
      settings.inbounds = [
        {
          type = "hysteria2";
          listen = "::";
          listen_port = 8080;
          inherit users tls;
        }
        {
          type = "trojan";
          listen = "::";
          listen_port = 8443;
          inherit users tls;
          multiplex.enabled = true;
        }
      ];
    };
    systemd.services.sing-box = {
      wants = [ "acme-${cfg.domain}.service" ];
      after = [ "acme-${cfg.domain}.service" ];
    };
  };
}
