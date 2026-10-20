{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.clouddrive;
in
{
  options.services.clouddrive = {
    enable = lib.mkEnableOption "clouddrive2";
    package = lib.mkPackageOption pkgs "clouddrive2" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.clouddrive2 = {
      description = "clouddrive2";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.CLOUDDRIVE_HOME = "/var/lib/clouddrive2";
      serviceConfig = {
        Type = "exec";
        ExecStart = lib.getExe cfg.package;
        StateDirectory = "clouddrive2";
        Restart = "on-failure";
      };
    };
  };
}
