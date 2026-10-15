{
  pkgs,
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
    cloud = lib.mkEnableOption "tsssni.infra.wired.cloud";
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

    systemd.services.clouddrive2 = lib.mkIf cfg.cloud {
      description = "clouddrive2";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.CLOUDDRIVE_HOME = "/var/lib/clouddrive2";
      serviceConfig = {
        Type = "exec";
        ExecStart = lib.getExe pkgs.clouddrive2;
        StateDirectory = "clouddrive2";
        Restart = "on-failure";
      };
    };
  };
}
