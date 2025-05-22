{ ... }:
{
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
}
