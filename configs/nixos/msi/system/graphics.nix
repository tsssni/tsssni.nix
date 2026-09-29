{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.steam ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    steam-hardware.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      package = config.hardware.nvidia.package;
      package32 = config.hardware.nvidia.package.lib32;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      modesetting.enable = true;
    };
  };
}
