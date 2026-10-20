{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.infra.wired;
in
{
  options.tsssni.infra.wired = {
    enable = lib.mkEnableOption "tsssni.infra.wired";
    host = lib.mkOption {
      type = lib.types.str;
      default = "tsssni";
    };
    tunnel = lib.mkEnableOption "tsssni.infra.wired.tunnel";
    wireless = lib.mkEnableOption "tsssni.infra.wired.wireless" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfg.host;
      hostId = "01145140";
      useDHCP = lib.mkDefault true;
      useNetworkd = !cfg.wireless;
      nameservers = lib.mkIf (!cfg.wireless) [ "223.5.5.5" ];
      firewall.enable = false;
      networkmanager = lib.mkIf cfg.wireless {
        enable = true;
        wifi.backend = "iwd";
      };
      modemmanager.enable = false;
    };
    services = {
      openssh.enable = lib.mkIf cfg.tunnel true;
      resolved.enable = lib.mkIf (!cfg.wireless) false;
    };
    programs.ssh.startAgent = lib.mkIf cfg.tunnel true;
  };
}
