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
    launchd.daemons.clouddrive2 = {
      script = ''
        mkdir -p /var/lib/clouddrive2
        exec ${lib.getExe cfg.package}
      '';
      serviceConfig = {
        EnvironmentVariables.CLOUDDRIVE_HOME = "/var/lib/clouddrive2";
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
