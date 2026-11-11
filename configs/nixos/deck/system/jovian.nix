{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.steam.enable = false;

  systemd.user.services = {
    orca.enable = false;
    gamescope-session = {
      overrideStrategy = "asDropin";
      enableDefaultPath = false;
      restartIfChanged = false;
    };
  };

  xdg.portal.configPackages = [ pkgs.jovianPackages.gamescope-session ];

  jovian = {
    devices.steamdeck.enable = true;
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = false;
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
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.jovian.steam.user;
      };
      defaultSession = "gamescope-wayland";
      ly = {
        enable = true;
        x11Support = false;
        settings.session_log = ".local/state/ly-session.log";
      };
    };
    orca.enable = false;
    speechd.enable = false;
  };
}
