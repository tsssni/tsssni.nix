{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.steam.override { locales = config.i18n.glibcLocales; })
  ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    steam-hardware.enable = true;
    graphics = {
      enable = true;
      package = config.hardware.nvidia.package;
    };
    nvidia = {
      package = pkgs.nvidia-path-tracing.override { linuxPackages = config.boot.kernelPackages; };
      open = true;
      modesetting.enable = true;
      nvidiaSettings = false;
    };
  };
}
