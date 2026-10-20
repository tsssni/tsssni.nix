{
  pkgs,
  config,
  ...
}:
{
  tsssni.infra.light = with pkgs; {
    enable = true;
    replace = {
      boost189 = boost189_1;
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
    scopes.qt6 = qt6Basic;
    clear = [ qt6.qttranslations ];
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
