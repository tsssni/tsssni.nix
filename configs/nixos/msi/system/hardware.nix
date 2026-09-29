{
  pkgs,
  ...
}:
{
  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = [
      (pkgs.runCommand "minimal-firmware" { passthru.compressFirmware = false; } ''
        fw=${pkgs.compressFirmwareZstd pkgs.linux-firmware}/lib/firmware
        mkdir -p $out/lib/firmware/{mediatek,rtl_nic}
        cp $fw/mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin.zst $out/lib/firmware/mediatek/
        cp $fw/rtl_nic/rtl8125b-2.fw.zst $out/lib/firmware/rtl_nic/
      '')
    ];
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    hardware.openrgb = {
      enable = true;
      startupProfile = "tsssni";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
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
