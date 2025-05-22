{
  config,
  tsssni,
  ...
}:
{
  wsl = {
    enable = true;
    defaultUser = "wsl";
    startMenuLaunchers = true;
    wslConf.network.hostname = tsssni.func;
  };

  users.users.wsl = {
    name = "wsl";
    home = "/home/wsl";
    shell = config.tsssni.shell.shell.package;
    hashedPassword = "$y$j9T$VvZ/yXQDMqfPz.CviVzJy/$Tq6nK6AzUPppFUjzenqKmkRZpVT4dZM2gs2YpadzdaB";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };

  system.stateVersion = "24.11";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
}
