{
  pkgs,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux-lean.override {
        dotconfig = ./config/kernel/kernel.config;
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

  services = {
    userborn.enable = true;
    lvm.enable = false;
    speechd.enable = false;
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.users.users.tsssni.name;
      };
      defaultSession = "niri";
      ly = {
        enable = true;
        x11Support = false;
        settings.session_log = ".local/state/ly-session.log";
      };
      sessionPackages = [ pkgs.niri ];
    };
  };

  system = {
    disableInstallerTools = true;
    etc.overlay.enable = true;
    stateVersion = "24.11";
  };
  systemd = {
    package = pkgs.systemd-lean;
    packages = [ pkgs.niri ];
  };
  security.polkit.enable = true;
  tsssni.infra.shell.enable = true;

  programs.nano.enable = false;
  documentation.man.enable = false;
  fonts.enableDefaultPackages = false;
  xdg.sounds.enable = false;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
}
