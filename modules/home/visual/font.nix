{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.font;
in
{
  options.tsssni.visual.font = {
    enable = lib.mkEnableOption "tsssni.visual.font";
    nerdFont = lib.mkOption {
      type = lib.hm.types.fontType;
      default = {
        package = pkgs.nerd-fonts.blex-mono;
        name = "BlexMono Nerd Font";
        size = 16;
      };
      description = ''
        nerd font
      '';
    };
    latinFont = lib.mkOption {
      type = lib.hm.types.fontType;
      default = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Mono";
        size = 16;
      };
      description = ''
        latin font
      '';
    };
    emojiFont = lib.mkOption {
      type = lib.hm.types.fontType;
      default = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
        size = 16;
      };
      description = ''
        emoji font
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [
      nerdFont.package
      latinFont.package
      emojiFont.package
    ];
  };
}
