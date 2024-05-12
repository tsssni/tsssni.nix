{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };

	home = {
    packages = with pkgs; [ 
      swww
      grim
      slurp
    ];

		file.".config/hypr" = {
			source = ./config/hypr;
			recursive = true;
		};
	};
  
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" ];
    };
  };
}
