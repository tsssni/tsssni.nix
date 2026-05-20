{ ... }:
{
  tsssni.infra = {
    wired = {
      enable = true;
      host = "msi";
      tunnel = true;
    };
    crypto = {
      enable = true;
      passwd = ../../../../assets/infra/passwd.age;
      domains = [
        "tsssni.top"
        "tsssni.biz"
      ];
    };
  };

  services.samba = {
    enable = true;
    settings.samba.path = "/home/samba";
  };
}
