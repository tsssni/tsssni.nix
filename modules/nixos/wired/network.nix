{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.wired.network;
in
{
  options.tsssni.wired.network = {
    enable = lib.mkEnableOption "tsssni.wired.network";
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "tsssni";
      description = "Host name for the tsssni wired network.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      hostId = "01145140";
      useDHCP = lib.mkDefault true;
      firewall.enable = false;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  };
}
