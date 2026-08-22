{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.intef.stream;
  app = "PlayStation Deck";
  artwork = "${pkgs.chiaki-ng.src}/gui/res";
  grid = ".steam/steam/userdata/${toString cfg.steam}/config/grid";
  appid = "2793299196";
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

    home.file = lib.mkIf (cfg.steam != null) {
      "${grid}/${appid}.png".source = "${artwork}/steam_landscape.png";
      "${grid}/${appid}p.png".source = "${artwork}/steam_portrait.png";
      "${grid}/${appid}_hero.png".source = "${artwork}/steam_hero.png";
      "${grid}/${appid}_logo.png".source = "${artwork}/steam_logo.png";
    };

    services.steam-shortcuts = lib.mkIf (cfg.steam != null) {
      enable = true;
      steamUserId = cfg.steam;
      overwriteExisting = true;
      shortcuts = [
        {
          AppName = app;
          Exe = lib.getExe pkgs.chiaki-ng;
          StartDir = config.home.homeDirectory;
          LaunchOptions = "env -u LD_PRELOAD %command%";
          Icon = "${artwork}/steam_icon.png";
        }
      ];
    };
  };
}
