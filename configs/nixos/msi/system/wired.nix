{ ... }:
{
  tsssni.infra = {
    wired = {
      enable = true;
      host = "msi";
      tunnel = true;
    };
    crypto.enable = true;
  };

  services.samba = {
    enable = true;
    settings.samba.path = "/home/samba";
  };
}
