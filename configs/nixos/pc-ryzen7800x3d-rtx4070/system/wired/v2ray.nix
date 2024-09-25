{ ... }:
{
  services.v2ray = {
    enable = true;
    config = {
      inbounds = [
        {
          tag = "http";
          port = 7890;
          listen = "127.0.0.1";
          protocol = "http";
          settings.timeout = 60;
        }
        {
          tag = "transparent";
          port = 12345;
          protocol = "dokodemo-door";
          settings = {
            network = "tcp,udp";
            followRedirect = true;
          };
          sniffing = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
            ];
          };
          streamSettings.sockopt.tproxy = "tproxy";
        }
      ];
      outbounds = [
        {
          tag = "wired";
          protocol = "freedom";
          settings = {};
        }
        {
          tag = "trojan";
          protocol = "trojan";
          settings.servers = [
            {
              address = "";
              port = 443;
              password = "";
            }
          ];
          streamSettings = {
            network = "tcp";
            security = "tls";
            tlsSettings.serverName = "";
          };
        }
        {
          tag = "nameserver";
          protocol = "dns";
          settings.address = "1.1.1.1";
        }
      ];
      routing = {
        domainStrategy = "AsIs";
        domainMatcher = "mph";
        rules = [
          {
            inboundTag = "transparent";
            outboundTag = "dns";
            type = "field";
            port = 53;
          }
          {
            outboundTag = "wired";
            type = "field";
            domains = [
              "cc98.org"
              "bilibili.com"
              "geosite:cn"
            ];
          }
          {
            outboundTag = "wired";
            type = "field";
            ip = [
              "geoip:cn"
              "geoip:private"
            ];
          }
          {
            outboundTag = "trojan";
            type = "field";
            network = "udp,tcp";
          }
        ];
      };
    };
  };
}
