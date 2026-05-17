{
  lib,
  config,
  ...
}:
{
  boot = {
    kernelParams = [
      "audit=0"
      "net.ifnames=0"
    ];
    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "virtio_pci"
        "virtio_blk"
        "virtio_scsi"
        "virtio_net"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
      ];
    };
    loader.grub = {
      enable = !config.boot.isContainer;
      default = "saved";
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

  system.stateVersion = "24.11";
  time.timeZone = "Asia/Tokyo";
  nix = {
    gc.automatic = lib.mkForce false;
    optimise.automatic = lib.mkForce false;
  };
}
