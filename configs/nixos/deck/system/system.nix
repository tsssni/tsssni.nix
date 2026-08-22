{
  config,
  ...
}:
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
      consoleMode = "5";
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
  };

  security.pki.certificateFiles = [ ../../../../assets/intef/comodo-rsa-dv.pem ];
  services = {
    displayManager.sddm.wayland.enable = true;
    openssh.settings.PasswordAuthentication = false;
  };

  users.users.deck = {
    name = "deck";
    home = "/home/deck";
    shell = config.tsssni.infra.shell.package;
    hashedPassword = "$6$C2DsafvrEGoy3g8A$gV9LFctSY7A1WHJk8sjwY6hu04zTldhHH6LWayvUBSm3D8s9oW//jqbVDv0VVD00BcH8QScp4leXzjmSqvieT.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOt/rZeCaRCYQAfdwkxwN3SuHqFfj7tP3sPDkSZ5tBjI dingyongyu2002@foxmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcuEh4+o7omR+JR/zXw5Psw5dPN7ocRafhHEo4nUXnw dingyongyu2002@foxmail.com"
    ];
    extraGroups = [
      "wheel"
      "systemd-journal"
    ];
    isNormalUser = true;
  };

  tsssni.infra.shell.enable = true;
  system.stateVersion = "24.11";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
}
