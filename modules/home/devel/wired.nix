{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.wired;
in
{
  options.tsssni.devel.wired = {
    enable = lib.mkEnableOption "tsssni.devel.wired";
    tunnel = lib.mkEnableOption "tsssni.devel.wired.tunnel";
    firefox = lib.mkEnableOption "tsssni.devel.wired.browser";
    google = lib.mkEnableOption "tsssni.devel.wired.google";
    cloud = lib.mkEnableOption "tsssni.devel.wired.cloud";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        _7zz
      ]
      ++ lib.optionals cfg.tunnel [
        wireguard-tools
      ]
      ++ lib.optionals cfg.cloud [
        clouddrive2
      ];

    programs = {
      ssh = lib.mkIf cfg.tunnel {
        enable = true;
        enableDefaultConfig = false;
        includes = [
          "~/.ssh/config.d/*"
        ];
        settings."*" = {
          forwardAgent = true;
          addKeysToAgent = "yes";
          hashKnownHosts = true;
        };
      };

      firefox = lib.mkIf cfg.firefox {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };

      google-chrome = lib.mkIf cfg.google {
        enable = true;
      };
    };
  };
}
