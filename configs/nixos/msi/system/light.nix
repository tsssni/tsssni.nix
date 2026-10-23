{
  pkgs,
  config,
  ...
}:
{
  tsssni.infra.light = with pkgs; {
    enable = true;
    replace = {
      adwaita-icon-theme = adwaita-icons;
      "ffmpeg.lib" = ffmpeg-decode.lib;
      gettext = gettext-runtime;
      gitMinimal = git-light;
      librime = rime-arisa.librime;
      networkmanager = wiredmanager;
      pipewire = pipewire-direct;
      python3 = python3-convex;
      systemd = config.systemd.package;
      xdg-utils = xdg-utils-perless;
    };
    scopes = {
      gst_all_1 = gstPackages;
      qt6 = qt6Basic;
    };
    clear = [
      qt6.qttranslations
      qt6.qtwayland
    ];
  };
}
