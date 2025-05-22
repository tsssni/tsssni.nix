{
  config,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
  };

  users.users.deck = {
    name = "deck";
    home = "/home/deck";
    shell = config.tsssni.shell.shell.package;
    hashedPassword = "$6$C2DsafvrEGoy3g8A$gV9LFctSY7A1WHJk8sjwY6hu04zTldhHH6LWayvUBSm3D8s9oW//jqbVDv0VVD00BcH8QScp4leXzjmSqvieT.";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };

  system.stateVersion = "24.11";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
}
