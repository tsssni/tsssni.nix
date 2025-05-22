{
  tsssni,
  ...
}:
{
  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [ "38.59.242.113/22" ];
      gateway = [ "38.59.240.1" ];
      matchConfig.Name = "eth0";
    };
  };
  services.resolved.enable = false;
  networking = {
    hostName = tsssni.func;
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
    useDHCP = false;
  };
}
