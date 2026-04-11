{
  pkgs,
  lib,
  config,
  ...
}:
{
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      startupProfile = "tsssni";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.extraConfig."controller" = {
        "monitor.alsa.rules" = [{
          matches = [{ "alsa.id" = "Controller"; }];
          actions.update-props."priority.session" = 100;
        }];
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "zpool";
      fsType = "zfs";
    };

    "/efi" = {
      device = "/dev/disk/by-uuid/4757-51E1";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ ];
}
