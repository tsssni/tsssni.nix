{
  pkgs
, ...
}:
{
	boot.loader = {
		grub = {
			enable = true;
			zfsSupport = true;
			efiSupport = true;
			useOSProber = true;
			mirroredBoots = [
				{
					devices = [ "nodev" ];
					path = "/efi";
				}
			];
			theme = pkgs.tsssni.plana-grub;
			configurationLimit = 5;
		};
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/efi";
		};
	};
}
