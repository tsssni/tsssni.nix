{ pkgs, ... }: 
{
	home = {
		file.".config/hypr" = {
			source = ./config;
			recursive = true;
		};
	};

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
