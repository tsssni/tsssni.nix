{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.intef.stream;
  launcher = "${config.home.homeDirectory}/.local/bin/chiaki-launcher.sh";
in
{
  options.tsssni.intef.stream = {
    enable = lib.mkEnableOption "tsssni.intef.stream";
    steam = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      description = ''
        Steam user id the chiaki-ng shortcut is registered under, as found in
        ~/.local/share/Steam/userdata. Null keeps the shortcut unmanaged.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.chiaki-ng ];

    services.steam-shortcuts = lib.mkIf (cfg.steam != null) {
      enable = true;
      steamUserId = cfg.steam;
      overwriteExisting = true;
      shortcuts = [
        {
          AppName = "chiaki-ng";
          Exe = launcher;
          StartDir = dirOf launcher;
        }
      ];
    };
  };
}
