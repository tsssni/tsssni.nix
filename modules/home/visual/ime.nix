{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.ime;
  homeCfg = config.tsssni.home;
  allowedTypes = lib.types.enum (
    if pkgs.stdenv.isLinux then [
      "fcitx5"
      "ibus"
    ]
    else if pkgs.stdenv.isDarwin then [
      "squirrel"
    ]
    else [ ]
  );
  tuiCfg = config.tsssni.visual.theme.tui;
  fontCfg = tuiCfg.font;
  ibusRime = pkgs.ibus-engines.rime.override {
    rimeDataPkgs = [
      pkgs.rime-arisa
    ];
  };
  fcitx5Cfg = {
    addons = with pkgs; [
      fcitx5-fluent
      fcitx5-mozc
      (fcitx5-rime.override {
        rimeDataPkgs = [
          rime-arisa
        ];
      })
    ];
    waylandFrontend = true;
    settings = {
      addons = {
        classicui.globalSection =
          let
            uiFont = fontCfg.nerdFont.name + " 10";
          in
          lib.optionalAttrs tuiCfg.enable {
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
    type = lib.mkOption {
      type = lib.types.nullOr allowedTypes;
      default = "fcitx5";
      example = "fcitx5";
      description = ''
        Select the enabled input method.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = lib.optionalAttrs pkgs.stdenv.isLinux ({
      enable = true;
      type = cfg.type;
    }
    // lib.optionalAttrs (cfg.type == "fcitx5") {
      fcitx5 = fcitx5Cfg;
    }
    // lib.optionalAttrs (cfg.type == "ibus") {
      ibus.engines = [ ibusRime ];
    });
    home.file =
      let
        path =
          if (cfg.type == "squirrel") then
            "Library/Rime"
          else if (cfg.type == "fcitx5") then
            ".local/share/fcitx5/rime"
          else
            null;
      in
      lib.optionalAttrs (path != null && (homeCfg.standalone || pkgs.stdenv.isDarwin)) {
        "${path}" = {
          source = "${pkgs.rime-arisa}/share/rime-data";
          recursive = true;
          force = true;
        };
      };
  };
}
