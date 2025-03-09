{
  pkgs
, ...
}:
{
	boot = {
		initrd = {
			availableKernelModules = [
				"nvme"
				"xhci_pci"
				"ahci"
				"usbhid"
				"usb_storage"
				"sd_mod"
				"sr_mod"
				"sdhci_pci"
				"amdgpu"
				"xhci_hcd"
				"hid_generic"
				"atkbd"
				"evdev"
			];
			kernelModules = [ ];
		};
		kernelPackages = pkgs.linuxPackages;
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];
	};
}
