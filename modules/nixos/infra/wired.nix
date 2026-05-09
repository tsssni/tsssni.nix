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
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfg.host;
      hostId = "01145140";
      useDHCP = lib.mkDefault true;
      firewall.enable = false;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
    services.openssh.enable = lib.mkIf cfg.tunnel true;
    programs.ssh.startAgent = lib.mkIf cfg.tunnel true;
  };
}
