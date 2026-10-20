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
    [
      "x-western"
      "zh-CN"
      "zh-HK"
      "zh-TW"
      "ja"
    ]
    |> map (lang: {
      "font.name.sans-serif.${lang}" = fontCfg.sansFont.name;
      "font.name.serif.${lang}" = fontCfg.serifFont.name;
      "font.name.monospace.${lang}" = fontCfg.monoFont.name;
      "font.name-list.sans-serif.${lang}" = "${fontCfg.sansFont.name}, ${fontCfg.monoFont.name}";
      "font.name-list.serif.${lang}" = "${fontCfg.serifFont.name}, ${fontCfg.monoFont.name}";
    })
    |> lib.mergeAttrsList
    |> lib.mergeAttrs { "font.name.serif.x-math" = fontCfg.mathFont.name; };

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
        package = homeCfg.install pkgs.firefox-bin;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.default = {
          id = 0;
          path = "9g6muneu.default";
          isDefault = true;
          settings = {
            "browser.toolbars.bookmarks.visibility" = "never";
            "widget.use-xdg-desktop-portal.file-picker" = 1;
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
