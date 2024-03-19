{ config, lib, pkgs, ... }:

{
	imports = [ ./hardware.nix ];

	boot.loader = {
		systemd-boot = {
			enable = true;
			configurationLimit = 10;
		};
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/efi";
		};
	};

	networking = {
		hostName = "tsssni";
		networkmanager.enable = true;
		proxy = {
			default = "127.0.0.1:7890";
			noProxy = "127.0.0.1,localhost,internal.domain";
		};
	};

	services = {
		xserver.videoDrivers = [ "nvidia" ];

		pipewire = {
			enable = true;
			alsa.enable = true;
			pulse.enable = true;
		};

		v2raya.enable = true;
		openssh.enable = true;
	};

	hardware = {
		opengl.enable = true;
		nvidia = {
			package = config.boot.kernelPackages.nvidiaPackages.latest;
			open = false;
			modesetting.enable = true;
		};

		bluetooth = {
			enable = true;
			powerOnBoot = true;
		};
	};

  	time.timeZone = "Asia/Shanghai";

  	i18n.defaultLocale = "en_US.UTF-8";

	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;
		};
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 1w";
		};
	};

	nixpkgs.config.allowUnfree = true;

	users.users.tsssni = {
		name = "tsssni";
		home = "/home/tsssni";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
	};

  	environment = {
		systemPackages = with pkgs; [ git vim wget curl ];
		variables.EDITOR = "vim";
	};

  	system.stateVersion = "23.11";

}

