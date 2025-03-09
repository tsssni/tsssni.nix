{
  pkgs
, ...
}:
{
	home.packages = with pkgs; [
		# fonts
		nerd-fonts.blex-mono
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-color-emoji
		# for gtk
		dconf
	];
}
