{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.wired.sing-box;
in
{
  options.tsssni.wired.sing-box = {
    enable = lib.mkEnableOption "tsssni.wired.sing-box";
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      "sbx-passwd" = {
        file = ./config/sbx-passwd.age;
        mode = "440";
      };
      "sbx-server" = {
        file = ./config/sbx-server.age;
        mode = "440";
      };
    };
    services.sing-box = {
      enable = true;
      settings = {
        dns = {
          servers = [
            {
              tag = "local";
              type = "udp";
              server = "223.5.5.5";
            }
            {
              tag = "remote";
              type = "fakeip";
              inet4_range = "198.18.0.0/15";
              inet6_range = "fc00::/18";
            }
          ];
          rules = [
            {
              rule_set = [
                "geosite-cn"
                "geosite-geolocation-cn"
                "geosite-steam@cn"
                "geosite-category-games@cn"
              ];
              server = "local";
            }
            {
              query_type = [
                "A"
                "AAAA"
              ];
              server = "remote";
            }
          ];
          strategy = "ipv4_only";
          independent_cache = true;
        };
        inbounds = [
          {
            type = "tun";
            address = [
              "172.19.0.1/30"
              "fdfe:dcba:9876::1/126"
            ];
            auto_route = true;
            strict_route = false;
          }
        ];
        outbounds = [
          {
            type = "trojan";
            tag = "wired";
            server._secret = config.age.secrets."sbx-server".path;
            server_port = 8443;
            password._secret = config.age.secrets."sbx-passwd".path;
            tls = {
              enabled = true;
              server_name._secret = config.age.secrets."sbx-server".path;
            };
          }
          {
            type = "direct";
            tag = "direct";
          }
        ];
        route = {
          rules = [
            {
              action = "sniff";
            }
            {
              protocol = "dns";
              action = "hijack-dns";
            }
            {
              ip_is_private = true;
              outbound = "direct";
            }
            {
              rule_set = [
                "geoip-cn"
                "geosite-cn"
                "geosite-geolocation-cn"
                "geosite-steam@cn"
                "geosite-category-games@cn"
              ];
              outbound = "direct";
            }
            {
              domain = [
                "time.apple.com"
                "time.windows.com"
                "pool.ntp.org"
              ];
              port = 123;
              protocol = "udp";
              outbound = "direct";
            }
            {
              domain_keyword = [
                "steamserver"
                "bilibili"
                "zju"
                "cc98"
              ];
              outbound = "direct";
            }
            {
              domain = "github.com";
              port = 22;
              outbound = "wired";
            }
            {
              port = [
                22
                2222
              ];
              outbound = "direct";
            }
          ];
          rule_set = [
            {
              type = "local";
              tag = "geoip-cn";
              format = "binary";
              path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
            }
            {
              type = "local";
              tag = "geosite-cn";
              format = "binary";
              path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
            }
            {
              type = "local";
              tag = "geosite-geolocation-cn";
              format = "binary";
              path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-geolocation-cn.srs";
            }
            {
              type = "local";
              tag = "geosite-category-games@cn";
              format = "binary";
              path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-category-games@cn.srs";
            }
            {
              type = "local";
              tag = "geosite-steam@cn";
              format = "binary";
              path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-steam@cn.srs";
            }
          ];
          default_domain_resolver = "local";
          auto_detect_interface = true;
        };
      };
    };
  };
}
