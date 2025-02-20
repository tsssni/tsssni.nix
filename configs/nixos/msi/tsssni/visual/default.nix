{
  pkgs
, ...
}:
{
	home.packages = with pkgs; [ 
		wl-clipboard
	];

	imports = [
		./fcitx.nix
		./hyprland.nix
		./ags.nix
		./theme.nix
		./yoasobi.nix
	];
}
