{ ... }:
{
  tsssni.infra = {
    crypto = {
      enable = true;
      broadcast = "192.168.60.1";
      passwd = ../../../../assets/infra/passwd.age;
      domains = [
        "tsssni.top"
        "tsssni.biz"
      ];
    };
    wired = {
      enable = true;
      host = "deck";
      tunnel = true;
    };
  };

  networking.networkmanager.ensureProfiles.profiles.deck-lan = {
    connection = {
      id = "deck-lan";
      type = "ethernet";
      interface-name = "enp4s0f3u1u1";
      autoconnect = true;
    };
    ipv4 = {
      method = "manual";
      address1 = "192.168.60.1/24";
      never-default = true;
    };
    ipv6.method = "disabled";
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      port = 0;
      interface = "enp4s0f3u1u1";
      bind-dynamic = true;
      dhcp-range = "192.168.60.10,192.168.60.100,255.255.255.0,7d";
      dhcp-option = [
        "option:router"
        "option:dns-server"
      ];
    };
  };

  # keep sing-box available while ethernet is unplugged.
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;
}
