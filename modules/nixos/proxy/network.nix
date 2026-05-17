{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.proxy;
in
{
  config = lib.mkIf cfg.enable {
    systemd.network = {
      enable = true;
      networks.eth0 = {
        inherit (cfg) address gateway;
        matchConfig.Name = "eth0";
      };
    };
    services = {
      resolved.enable = false;
      openssh = {
        enable = true;
        ports = [ 2222 ];
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = lib.mkForce "prohibit-password";
        };
      };
    };
    networking = {
      hostName = cfg.hostName;
      nameservers = [ "8.8.8.8" ];
      firewall.enable = false;
      useDHCP = false;
    };
  };
}
