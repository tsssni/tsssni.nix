{
  pkgs,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ "kvm-amd" ];
    blacklistedKernelModules = [
      "amdgpu"
      "mt7921e"
    ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options nvidia NVreg_RestrictProfilingToAdminUsers=0
    '';
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
        theme = pkgs.hyperfluent-grub-theme;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
    zfs.forceImportRoot = true;
  };

  users.users.tsssni = {
    name = "tsssni";
    home = "/home/tsssni";
    shell = config.tsssni.infra.shell.package;
    hashedPassword = "$y$j9T$mzXj7DKn7uD9EWbb.EdTo0$Yix0Fy713KpDwzwYF4K3yYAWhMlyR7Acy8SU81lx7Q5";
    extraGroups = [
      "wheel"
      "systemd-journal"
      "webdav"
    ];
    isNormalUser = true;
  };

  system = {
    disableInstallerTools = true;
    stateVersion = "24.11";
  };
  services.userborn.enable = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  tsssni.infra.shell.enable = true;
}
