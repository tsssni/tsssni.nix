{ ... }:
let
  root = "/var/lib/webdav/data";
in
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

  services.webdav = {
    enable = true;
    settings = {
      address = "0.0.0.0";
      port = 8080;
      directory = root;
      permissions = "R";
      users = [
        {
          username = "tsssni";
          password = "{bcrypt}$2b$10$9BLg/F5nkUzEJXTaiVgbQuF5fztgkyUzy62E9GRnnijGrUo8.4nSm";
        }
      ];
    };
  };

  systemd.services.webdav.serviceConfig = {
    StateDirectory = "webdav/data";
    StateDirectoryMode = "2770";
  };
}
