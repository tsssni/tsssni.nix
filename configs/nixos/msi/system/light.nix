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
      boost189 = boost189_1;
      "ffmpeg.lib" = ffmpeg-decode.lib;
      gettext = gettext-runtime;
      glibc = glibc-utf8;
      gtk3 = gtk3_1;
      hwdata = hwdata-lan;
      icu = icu-en;
      iproute2 = iproute-wired;
      "libpcap.lib" = libpcap-plain.lib;
      ncurses = ncurses-alacritty;
      pipewire = pipewire-direct;
      python3 = python3-convex;
      systemd = config.systemd.package;
      systemdMinimal = systemd-minimal-lean;
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
    core = [
      cpio
      gnupatch
      host
      mkpasswd
      netcat
      time
    ];
  };
}
