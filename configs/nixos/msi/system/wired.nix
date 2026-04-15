{ ... }:
{
  tsssni = {
    wired = {
      network = {
        enable = true;
        hostName = "msi";
      };
      sing-box.enable = true;
      ssh.enable = true;
    };
    secret.enable = true;
  };

  services.samba = {
    enable = true;
    settings.samba.path = "/home/samba";
  };
}
