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
      postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        				# Set the system time from the hardware clock to work around a
        				# bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
        				# to the *boot time* of the host).
        				hwclock -s
        			'';
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
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
    users = {
      root = {
        hashedPassword = "$6$/iX/pVpA5bEKVLCq$QOFRlw8zemSplLXeai8hO/D4AVrlDcMRPDIpKFSGI4bs9SlyiCHZMGmb05YAuCA4UrdDCpnsqfKFHHFfCnbRp.";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINs7JUeKdbtr8B1tAdyNIlRjedkVreAtKERKvAb4ltAq dingyongyu2002@foxmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJax0Eo+863xqIl7cHSAQKY8NP/cK3ea8R6OiIUWCtzT dingyongyu2002@foxmail.com"
        ];
      };
      nginx.extraGroups = [ "acme" ];
    };
  };

  system.stateVersion = "24.11";
  time.timeZone = "America/Los_Angeles";
}
