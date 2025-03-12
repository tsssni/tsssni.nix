{ ... }:
{
	boot = {
		initrd = {
			availableKernelModules = [
				"nvme"
				"xhci_pci"
				"usbhid"
				"sdhci_pci"
			];
			kernelModules = [ ];
		};
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];
	};
}
