{
  pkgs,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux-lean.override {
        dotconfig = ./kernel.config;
        kernelPatches = [ ];
      }
    );
    bcache.enable = false;
    kexec.enable = false;
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
        "hid_generic"
        "sd_mod"
      ];
      includeDefaultModules = false;
      kernelModules = [ ];
    };
    loader = {
      systemd-boot = {
        enable = true;
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
    etc.overlay.enable = true;
    stateVersion = "24.11";
  };
  services = {
    userborn.enable = true;
    lvm.enable = false;
  };
  security.polkit.enable = true;
  systemd.package = pkgs.systemd-lean;
  tsssni.infra.shell.enable = true;

  programs.nano.enable = false;
  documentation.man.enable = false;
  xdg.sounds.enable = false;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
}
