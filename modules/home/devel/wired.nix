{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.wired;
  homeCfg = config.tsssni.home;
  fontCfg = config.tsssni.devel.literal.font;

  fontSettings =
    {
      x-western = fontCfg.sansFont.name;
      zh-CN = fontCfg.hanzisFont.name;
      zh-HK = fontCfg.hanzitFont.name;
      zh-TW = fontCfg.hanzitFont.name;
      ja = fontCfg.kanjiFont.name;
      ko = fontCfg.hangulFont.name;
    }
    |> lib.mapAttrsToList (
      lang: sans: {
        "font.name.sans-serif.${lang}" = sans;
        "font.name.serif.${lang}" = if lang == "x-western" then fontCfg.serifFont.name else sans;
        "font.name.monospace.${lang}" = fontCfg.latinFont.name;
      }
    )
    |> lib.mergeAttrsList;

  aiSettings = {
    "extensions.ml.enabled" = false;
    "browser.tabs.groups.smart.enabled" = false;
    "browser.translations.enable" = false;
  }
  // (
    [
      "default"
      "linkPreviewKeyPoints"
      "pdfjsAltText"
      "sidebarChatbot"
      "smartTabGroups"
      "smartWindow"
      "translations"
    ]
    |> map (x: lib.nameValuePair "browser.ai.control.${x}" "blocked")
    |> builtins.listToAttrs
  );
in
{
  options.tsssni.devel.wired = {
    enable = lib.mkEnableOption "tsssni.devel.wired";
    tunnel = lib.mkEnableOption "tsssni.devel.wired.tunnel";
    firefox = lib.mkEnableOption "tsssni.devel.wired.browser";
  };

  config = lib.mkIf cfg.enable {
    mozilla.firefoxNativeMessagingHosts = lib.mkIf cfg.firefox (lib.mkForce [ ]);

    home.packages =
      with pkgs;
      [
        _7zz
      ]
      ++ lib.optionals cfg.tunnel [
        wireguard-tools
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
        package = homeCfg.install (pkgs.wrapFirefox pkgs.firefex { pname = "firefox-bin"; });
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.default = {
          id = 0;
          path = "9g6muneu.default";
          isDefault = true;
          settings = {
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.urlbar.suggest.bookmark" = false;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.topsites" = false;
            "sidebar.verticalTabs" = true;
            "media.eme.enabled" = true;
          }
          // aiSettings
          // fontSettings;
        };
      };
    };
  };
}
