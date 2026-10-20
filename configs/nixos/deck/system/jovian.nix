{
  lib,
  pkgs,
  ...
}:
{
  programs.steam.enable = false;

  systemd.user.services.orca.enable = false;

  jovian = {
    devices.steamdeck.enable = true;
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "gamescope-wayland";
      updater.splash = "jovian";
      user = "deck";
    };
  };

  hardware = {
    graphics.enable32Bit = lib.mkForce false;
    firmware = lib.mkForce (
      with pkgs;
      [
        (linux-firmware-lean [
          "amdgpu/vangogh_*"
          "ath11k/QCA2066/*"
          "qca/QCA2066/*"
          "qca/hpbtfw21*"
          "qca/hpnv21*"
        ])
        (lib.hiPrio jovianPackages.linux-firmware-holo)
        (lib.hiPrio jovianPackages.steamdeck-dsp)
        sof-firmware
        wireless-regdb
      ]
    );
  };

  services = {
    orca.enable = false;
    speechd.enable = false;
  };
}
