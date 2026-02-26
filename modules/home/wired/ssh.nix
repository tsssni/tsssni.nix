{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.wired.ssh;
in
{
  options.tsssni.wired.ssh = {
    enable = lib.mkEnableOption "tsssni.wired.ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
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
    home.packages = with pkgs; [
      _7zz
      curl
      wireguard-tools
    ];
  };
}
