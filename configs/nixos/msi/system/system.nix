{
  pkgs,
  config,
  ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
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
        theme = pkgs.plana-grub;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };

  users.users.tsssni = {
    name = "tsssni";
    home = "/home/tsssni";
    shell = config.tsssni.shell.shell.package;
    hashedPassword = "$y$j9T$mzXj7DKn7uD9EWbb.EdTo0$Yix0Fy713KpDwzwYF4K3yYAWhMlyR7Acy8SU81lx7Q5";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };

  system.stateVersion = "24.11";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
}
