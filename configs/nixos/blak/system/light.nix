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
      hwdata = hwdata-lan;
      icu = icu-en;
      iproute2 = iproute-wired;
      ncurses = ncurses-alacritty;
      systemd = config.systemd.package;
      systemdMinimal = systemd-minimal-lean;
    };
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
