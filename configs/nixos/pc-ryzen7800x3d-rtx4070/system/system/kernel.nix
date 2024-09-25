{
  pkgs
, ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
}
