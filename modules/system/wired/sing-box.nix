{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.wired.sing-box;
  geoip = [
    "geoip-cn"
  ];
  geosite = [
    "geosite-cn"
    "geosite-geolocation-cn"
    "geosite-steam@cn"
    "geosite-category-games@cn"
  ];
  rule_set = geoip ++ geosite;
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
    };
    services.sing-box = {
      enable = true;
      settings = {
        dns = {
          servers = [
            {
              tag = "cf";
              type = "tls";
              server = "1.1.1.1";
              detour = "wired";
            }
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
              rule_set = geosite;
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
        outbounds =
          let
            mkOutbound =
              attr: with attr; {
                inherit tag type server;
                server_port = if type == "hysteria2" then 8080 else 8443;
                password._secret = config.age.secrets."sbx-passwd".path;
                domain_resolver = "local";
                tls = {
                  enabled = true;
                  server_name = server;
                };
              };
            mkOutbounds =
              attrs:
              [
                {
                  type = "selector";
                  tag = "wired";
                  outbounds = (map (attr: attr.tag) attrs) ++ [ "direct" ];
                  default = "hy2";
                }
              ]
              ++ map (attr: mkOutbound attr) attrs
              ++ [
                {
                  type = "direct";
                  tag = "direct";
                  domain_resolver = "local";
                }
              ];
          in
          mkOutbounds [
            {
              tag = "hy1";
              type = "trojan";
              server = "tsssni.top";
            }
            {
              tag = "hy2";
              type = "hysteria2";
              server = "tsssni.top";
            }
            {
              tag = "hy3";
              type = "hysteria2";
              server = "tsssni.biz";
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
              inherit rule_set;
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
          rule_set = map (tag: {
            type = "local";
            inherit tag;
            format = "binary";
            path = "${
              if lib.hasPrefix "geoip" tag then pkgs.sing-geoip else pkgs.sing-geosite
            }/share/sing-box/rule-set/${tag}.srs";
          }) rule_set;
          auto_detect_interface = true;
          final = "wired";
        };
        experimental = {
          clash_api = {
            external_controller = "127.0.0.1:9090";
            external_ui = "${pkgs.metacubexd}";
          };
        };
      };
    };
  };
}
