{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux-lean.override {
        virtualized = true;
        dotconfig = ./config/kernel/kernel.config;
        kernelPatches = [ ];
      }
    );
    bcache.enable = false;
    kexec.enable = false;
    kernelParams = [
      "audit=0"
      "net.ifnames=0"
    ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = {
        atkbd = true;
        i8042 = true;
        virtio_pci = true;
        virtio_blk = true;
        virtio_scsi = true;
        virtio_net = true;
        efivarfs = lib.mkForce false;
      };
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
      ];
    };
    loader.grub = {
      enable = !config.boot.isContainer;
      default = "saved";
      splashImage = null;
      devices = [ "/dev/vda" ];
    };
  };

  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$UooUtFYrPCoXm4odhRJAr.$EgDe8gn5yyrywpEKprPCYyXXEzLu6I0TgjTzIDsULo5";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINs7JUeKdbtr8B1tAdyNIlRjedkVreAtKERKvAb4ltAq dingyongyu2002@foxmail.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJax0Eo+863xqIl7cHSAQKY8NP/cK3ea8R6OiIUWCtzT dingyongyu2002@foxmail.com"
      ];
    };
  };

  system = {
    disableInstallerTools = true;
    etc.overlay.enable = false;
    stateVersion = "24.11";
  };
  services = {
    userborn.enable = true;
    lvm.enable = false;
  };
  systemd.package = pkgs.systemd-lean;
  programs = {
    nano.enable = false;
    command-not-found.enable = false;
  };
  documentation.enable = false;
  xdg = {
    autostart.enable = false;
    icons.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };
  time.timeZone = "Asia/Tokyo";
  nix = {
    gc.automatic = lib.mkForce false;
    optimise.automatic = lib.mkForce false;
  };
}
