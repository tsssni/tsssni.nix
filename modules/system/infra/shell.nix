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
    enable = lib.mkEnableOption "tsssni.infra.shell";
    package = lib.mkPackageOption pkgs "nushell" { };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };
}
