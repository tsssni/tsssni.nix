{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.infra.shell;
in
{
  options.tsssni.infra.shell = {
    enable = lib.mkEnableOption "system shell integration";
    package = lib.mkPackageOption pkgs "nushell" { };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
