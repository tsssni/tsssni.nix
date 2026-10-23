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
    "#e0e2ea"
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
      if pkgs.stdenv.hostPlatform.isLinux then
        [
          "fcitx5"
          "ibus"
        ]
      else if pkgs.stdenv.hostPlatform.isDarwin then
        [ "squirrel" ]
      else
        [ ]
    )
  );
  inputType = cfg.input.type;

  rimePath =
    if (inputType == "squirrel") then
      "Library/Rime"
    else if (inputType == "fcitx5") then
      ".local/share/fcitx5/rime"
    else if (inputType == "ibus") then
      ".config/ibus/rime"
    else
      null;

  ibusRime = pkgs.ibus-engines.rime.override {
    rimeDataPkgs = [ pkgs.rime-arisa ];
  };
  ibusCfg = {
    engines = [ ibusRime ];
  };

  fcitx5Cfg = {
    fcitx5-with-addons = pkgs.fcitx5-arisa;
    addons = with pkgs; [
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [ rime-arisa ];
      })
    ];
    waylandFrontend = true;
    settings = {
      addons = {
        classicui.globalSection =
          let
            uiFont = fontCfg.latinFont.name + " 10";
          in
          {
            Font = uiFont;
            MenuFont = uiFont;
            TrayFont = uiFont;
            Theme = "FluentDark";
          };
        rime.globalSection.LatinModeNameFromSchema = "True";
      };
      globalOptions."Hotkey/TriggerKeys" = { };
      inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0".Name = "rime";
      };
    };
  };
in
{
  options.tsssni.devel.literal = {
    enable = lib.mkEnableOption "tsssni.devel.literal";
    font = {
      nerdFont = fontOption pkgs.plextina "Symbols Nerd Font";
      latinFont = fontOption pkgs.plextina "IBM Plex Mono";
      sansFont = fontOption pkgs.plextina "IBM Plex Sans";
      serifFont = fontOption pkgs.plextina "IBM Plex Serif";
      hanzisFont = fontOption pkgs.plextina "IBM Plex Sans SC";
      hanzitFont = fontOption pkgs.plextina "IBM Plex Sans TC";
      kanjiFont = fontOption pkgs.plextina "IBM Plex Sans JP";
      hangulFont = fontOption pkgs.plextina "IBM Plex Sans KR";
      emojiFont =
        if !pkgs.stdenv.hostPlatform.isDarwin then
          fontOption pkgs.noto-fonts-color-emoji "Noto Color Emoji"
        else
          fontOption null "Apple Color Emoji";
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
    tsssni.devel.literal.color = builtins.listToAttrs (
      lib.imap0 (i: x: {
        name = x;
        value = lib.mkDefault (builtins.elemAt colorCfg.palette i);
      }) colorList
    );

    fonts.fontconfig.defaultFonts = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
      let
        cjk =
          with fontCfg;
          [
            hanzisFont
            hanzitFont
            kanjiFont
            hangulFont
          ]
          |> map (f: f.name)
          |> lib.unique;
      in
      with fontCfg;
      {
        monospace = [
          latinFont.name
          nerdFont.name
        ]
        ++ cjk;
        sansSerif = [ sansFont.name ] ++ cjk;
        serif = [ serifFont.name ] ++ cjk;
        emoji = [ emojiFont.name ];
      }
    );

    i18n.inputMethod =
      lib.optionalAttrs (inputType != "none" && pkgs.stdenv.hostPlatform.isLinux && !homeCfg.standalone)
        (
          {
            enable = true;
            type = inputType;
          }
          // lib.optionalAttrs (inputType == "fcitx5") { fcitx5 = fcitx5Cfg; }
          // lib.optionalAttrs (inputType == "ibus") { ibus = ibusCfg; }
        );

    home = {
      sessionVariables = lib.optionalAttrs (inputType == "fcitx5") {
        GTK_IM_MODULE = "wayland";
      };
      activation.rimeBuild = lib.mkIf (rimePath != null) (
        lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
          rime="${config.home.homeDirectory}/${rimePath}"
          if [ "$(readlink "$rime/.rime-arisa")" != "${pkgs.rime-arisa}" ]; then
            run rm -rf "$rime/build"
            run mkdir -p "$rime"
            run ln -sfn "${pkgs.rime-arisa}" "$rime/.rime-arisa"
          fi
        ''
      );
      packages = lib.optionals (!homeCfg.standalone) (
        builtins.filter (p: p != null) (map (f: f.package) (builtins.attrValues fontCfg))
      );
      file = lib.mkIf (rimePath != null && (homeCfg.standalone || pkgs.stdenv.hostPlatform.isDarwin)) {
        "${rimePath}" = {
          source = "${pkgs.rime-arisa}/share/rime-data";
          recursive = true;
          force = true;
        };
      };
    };
  };
}
