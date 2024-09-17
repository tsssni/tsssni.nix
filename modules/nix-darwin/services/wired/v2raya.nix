{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.v2raya;
  assetsDir = with pkgs; symlinkJoin {
    name = "assets";
    paths = [ v2ray-geoip v2ray-domain-list-community ];
  };

in

{
  options = with types; {
    services.v2raya = {
      enable = mkEnableOption "v2raya"; 
      package = mkPackageOption pkgs "v2raya" {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.v2raya = {
      serviceConfig = {
        EnvironmentVariables = {
          V2RAYA_LOG_FILE = "/tmp/v2raya.log";
          V2RAYA_V2RAY_BIN = "${pkgs.v2ray}/bin/v2ray";
          XDG_DATA_DIR = "${assetsDir}/share";
        };
        ProgramArguments = [ "${cfg.package}/bin/v2raya" "--lite" ];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
