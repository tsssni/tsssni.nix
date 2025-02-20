{
  pkgs
, ...
}:
{
	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.addons = with pkgs; [
			fcitx5-gtk
			fcitx5-fluent
			fcitx5-chinese-addons
			fcitx5-pinyin-zhwiki
			fcitx5-pinyin-moegirl
		];
	};
}
