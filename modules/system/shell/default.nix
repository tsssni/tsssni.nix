{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.shell;
in
{
  options.tsssni.shell = {
    enable = lib.mkEnableOption "tsssni.shell";
    package = lib.mkPackageOption pkgs "nushell" { };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };
}
