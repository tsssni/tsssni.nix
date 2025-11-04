{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.ime;
in
{
  options.tsssni.visual.ime = {
    enable = lib.mkEnableOption "tsssni.visual.ime";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons =
        with pkgs;
        [
          fcitx5-gtk
          fcitx5-fluent
          fcitx5-mozc
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
        ]
        ++ (with pkgs.qt6Packages; [
          fcitx5-chinese-addons
        ]);
    };
  };
}
