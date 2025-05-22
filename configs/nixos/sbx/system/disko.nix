{ ... }:
{
  disko = {
    enableConfig = false;

    devices = {
      disk.main = {
        imageSize = "5G";
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 0;
            };
            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            nix = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "nosuid"
                  "nodev"
                ];
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/vda3";
      fsType = "ext4";
      options = [
        "nosuid"
        "nodev"
      ];
    };

    "/boot" = {
      device = "/dev/vda2";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
