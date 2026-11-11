{
  pkgs,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux-lean.override {
        linux = pkgs.jovianPackages.linux;
        dotconfig = ./config/kernel/kernel.config;
        kernelPatches = [ ];
      }
    );
    bcache.enable = false;
    kexec.enable = false;
    initrd.includeDefaultModules = false;
    loader = {
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
  };

  security.pki.certificateFiles = [ ../../../../assets/intef/comodo-rsa-dv.pem ];
  services = {
    openssh.settings.PasswordAuthentication = false;
    userborn.enable = true;
    lvm.enable = false;
  };

  users.users.deck = {
    name = "deck";
    home = "/home/deck";
    shell = config.tsssni.infra.shell.package;
    hashedPassword = "$y$j9T$RbIJsOOx4b/PpJOryla0n1$pYpVKXL7Lnbfkgv6sS/Dm7n9vd08hQfZu35.N.3hiyA";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOt/rZeCaRCYQAfdwkxwN3SuHqFfj7tP3sPDkSZ5tBjI dingyongyu2002@foxmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcuEh4+o7omR+JR/zXw5Psw5dPN7ocRafhHEo4nUXnw dingyongyu2002@foxmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdEVLnt+K+N5vIr8q5K1X8vSFY84roOqFIAc23OjEwy dingyongyu2002@foxmail.com"
    ];
    extraGroups = [
      "wheel"
      "systemd-journal"
    ];
    isNormalUser = true;
  };

  system = {
    disableInstallerTools = true;
    etc.overlay.enable = true;
    stateVersion = "24.11";
  };
  systemd.package = pkgs.systemd-lean;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  programs.nano.enable = false;
  fonts.enableDefaultPackages = false;
  xdg.sounds.enable = false;
  tsssni.infra.shell.enable = true;
}
