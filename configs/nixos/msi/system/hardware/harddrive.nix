{ ... }:
{
	fileSystems = {
		"/" = { 
			device = "zpool";
			fsType = "zfs";
		};

		"/efi" = { 
			device = "/dev/disk/by-uuid/4757-51E1";
			fsType = "vfat";
			options = [ "fmask=0022" "dmask=0022" ];
		};
	};

	swapDevices = [ ];
}
