{
  tsssni
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
			theme = tsssni.pkgs.plana-grub;
			configurationLimit = 5;
		};
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/efi";
		};
	};
}
