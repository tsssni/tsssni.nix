{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = false;
      modesetting.enable = true;
    };
  };
}
