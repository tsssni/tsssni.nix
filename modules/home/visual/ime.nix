{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.ime;
  font = config.tsssni.visual.font;
  fcitx5Cfg = {
    addons = with pkgs; [
      fcitx5-fluent
      fcitx5-mozc
      (fcitx5-rime.override {
        rimeDataPkgs = [
          rime-tsssni
        ];
      })
    ];
    waylandFrontend = true;
    settings = {
      addons = {
        classicui.globalSection =
          let
            uiFont = font.nerdFont.name + " 10";
          in
          {
            Font = uiFont;
            MenuFont = uiFont;
            TrayFont = uiFont;
            Theme = "FluentDark";
          };
      };
      globalOptions = {
        HotKey.EnumerateWithTriggerKeys = "True";
        "Hotkey/TriggerKeys"."0" = "Super+space";
      };
      inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "rime";
        "Groups/0/Items/2".Name = "mozc";
      };
    };
  };
in
{
  options.tsssni.visual.ime = {
    enable = lib.mkEnableOption "tsssni.visual.ime";
  };

  config = lib.mkIf cfg.enable {
    tsssni.visual.font.enable = true;
    i18n.inputMethod = lib.optionalAttrs pkgs.stdenv.isLinux {
      enable = true;
      type = "fcitx5";
      fcitx5 = fcitx5Cfg;
    };
    home.file = lib.optionalAttrs pkgs.stdenv.isDarwin {
      "Library/Rime" = {
        source = "${pkgs.rime-tsssni}/share/rime-data";
        recursive = true;
        force = true;
      };
    };
  };
}
