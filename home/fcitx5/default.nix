{ pkgs, ... }:
{

	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.addons = with pkgs; [ 
			fcitx5-configtool 
			fcitx5-chinese-addons
		];
	};

	home.file.".config/fcitx5" = {
		source = ./config;
		recursive = true;
	};
}
