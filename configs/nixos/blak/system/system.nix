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
        virtio_scsi = true;
        virtio_net = true;
        sd_mod = true;
        efivarfs = lib.mkForce false;
      };
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
      ];
    };
    loader.grub = {
      enable = !config.boot.isContainer;
      default = "saved";
      splashImage = null;
      devices = [ "/dev/sda" ];
    };
  };

  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$gdylE9ewEcj5VP/QGx.ww0$dJesetaJxGxYrShgyQMlV.XROgvjgKR8kJO7XkE2x33";
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
  time.timeZone = "America/Los_Angeles";
  nix = {
    gc.automatic = lib.mkForce false;
    optimise.automatic = lib.mkForce false;
  };
}
