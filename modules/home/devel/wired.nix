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
    browser = lib.mkEnableOption "tsssni.devel.wired.browser";
    cloud = lib.mkEnableOption "tsssni.devel.wired.cloud";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        _7zz
        curl
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
        matchBlocks."*" = {
          forwardAgent = true;
          addKeysToAgent = "yes";
          hashKnownHosts = true;
        };
      };

      firefox = lib.mkIf cfg.browser {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
    };
  };
}
