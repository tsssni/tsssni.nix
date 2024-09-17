{ ... }:
{
  services.v2ray = {
    enable = true;
    config = {
      inbounds = [
        {
          port = 7890;
          listen = "127.0.0.1";
          protocol = "http";
          settings.timeout = 60;
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
            tlsSettings.serverName = "carol.life";
          };
        } 
      ];
      routing = {
        domainStrategy = "AsIs";
        domainMatcher = "mph";
        rules = [
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
