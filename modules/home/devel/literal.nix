{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.literal;
  homeCfg = config.tsssni.home;
  colorCfg = cfg.color;
  fontCfg = cfg.font;
  colorOption =
    default:
    lib.mkOption {
      type = (with lib.types; nullOr str);
      inherit default;
    };
  fontOption =
    package: name:
    lib.mkOption {
      type = lib.hm.types.fontType;
      default = {
        inherit package name;
        size = 16;
      };
    };
  foreground = "#bebad9";
  background = "#303446";
  palette = [
    "#1a1730"
    "#f26dab"
    "#8ec794"
    "#e5c890"
    "#8499d9"
    "#a78dd4"
    "#7dd5d5"
    "#bebad9"
    "#514c73"
    "#ff8d7c"
    "#a8e5af"
    "#f5dba8"
    "#a0b4e5"
    "#c0a8e8"
    "#9fe5e5"
    "#d5d1e6"
  ];
  colorList = [
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
    "lightBlack"
    "lightRed"
    "lightGreen"
    "lightYellow"
    "lightBlue"
    "lightMagenta"
    "lightCyan"
    "lightWhite"
  ];
  inputTypes = lib.types.enum (
    [ "none" ]
    ++ (
      if pkgs.stdenv.isLinux then
        [
          "fcitx5"
          "ibus"
        ]
      else if pkgs.stdenv.isDarwin then
        [ "squirrel" ]
      else
        [ ]
    )
  );
  inputType = cfg.input.type;

  ibusRime = pkgs.ibus-engines.rime.override {
    rimeDataPkgs = [ pkgs.rime-arisa ];
  };
  ibusCfg = {
    engines = [ ibusRime ];
  };

  fcitx5Cfg = {
    addons = with pkgs; [
      fcitx5-fluent
      fcitx5-mozc
      (fcitx5-rime.override {
        rimeDataPkgs = [ rime-arisa ];
      })
    ];
    waylandFrontend = true;
    settings = {
      addons = {
        classicui.globalSection =
          let
            uiFont = fontCfg.nerdFont.name + " 10";
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
  options.tsssni.devel.literal = {
    enable = lib.mkEnableOption "tsssni.devel.literal";
    font = {
      nerdFont = fontOption pkgs.nerd-fonts.blex-mono "BlexMono Nerd Font";
      latinFont = fontOption pkgs.ibm-plex "IBM Plex Mono";
      hanzisFont = fontOption pkgs.ibm-plex "IBM Plex Sans SC";
      hanzitFont = fontOption pkgs.ibm-plex "IBM Plex Sans TC";
      kanjiFont = fontOption pkgs.ibm-plex "IBM Plex Sans JP";
      hangulFont = fontOption pkgs.ibm-plex "IBM Plex Sans KR";
      emojiFont = fontOption pkgs.noto-fonts-color-emoji "Noto Color Emoji";
    };
    color = {
      palette = lib.mkOption {
        type = with lib.types; listOf str;
        default = palette;
      };
      foreground = colorOption foreground;
      background = colorOption background;
    }
    // builtins.listToAttrs (
      map (x: {
        name = x;
        value = colorOption null;
      }) colorList
    );
    input.type = lib.mkOption {
      type = inputTypes;
      default = "none";
    };
  };

  config = lib.mkIf cfg.enable {
    tsssni = {
      devel.literal.color = builtins.listToAttrs (
        lib.imap0 (i: x: {
          name = x;
          value = lib.mkDefault (builtins.elemAt colorCfg.palette i);
        }) colorList
      );
      intef.shell.environmentVariables =
        { }
        // lib.optionalAttrs (inputType == "fcitx5") {
          GTK_IM_MODULE = "wayland";
        }
        // lib.optionalAttrs (inputType == "ibus" && homeCfg.standalone) {
          IBUS_COMPONENT_PATH = "/usr/share/ibus/component:${ibusRime}/share/ibus/component";
        };
    };

    i18n.inputMethod =
      lib.optionalAttrs (inputType != "none" && pkgs.stdenv.isLinux && !homeCfg.standalone)
        (
          {
            enable = true;
            type = inputType;
          }
          // lib.optionalAttrs (inputType == "fcitx5") { fcitx5 = fcitx5Cfg; }
          // lib.optionalAttrs (inputType == "ibus") { ibus = ibusCfg; }
        );

    home = {
      packages = with fontCfg; [
        nerdFont.package
        latinFont.package
        emojiFont.package
      ];
      file =
        let
          path =
            if (inputType == "squirrel") then
              "Library/Rime"
            else if (inputType == "fcitx5") then
              ".local/share/fcitx5/rime"
            else
              null;
        in
        lib.mkIf (inputType != "none" && path != null && (homeCfg.standalone || pkgs.stdenv.isDarwin)) {
          "${path}" = {
            source = "${pkgs.rime-arisa}/share/rime-data";
            recursive = true;
            force = true;
          };
        };
    };
  };
}
