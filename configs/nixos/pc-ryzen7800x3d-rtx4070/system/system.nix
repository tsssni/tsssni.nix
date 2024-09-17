{ pkgs, ... }:
{
  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

	users.users.tsssni = {
		name = "tsssni";
		home = "/home/tsssni";
    shell = pkgs.elvish;
		extraGroups = [ "wheel" ];
		isNormalUser = true;
	};

  environment = {
		systemPackages = with pkgs; [ 
      neovim 
      git
      curl
      wget
    ];
	};

  system.stateVersion = "24.05";
}

