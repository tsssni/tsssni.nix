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
      wireless = false;
    };
    crypto = {
      enable = true;
      broadcast = true;
      passwd = ../../../../assets/infra/passwd.age;
      domains = [
        "tsssni.top"
        "tsssni.biz"
      ];
    };
  };

  services = {
    clouddrive.enable = true;
    webdav = {
      enable = true;
      settings = {
        address = "0.0.0.0";
        port = 8080;
        directory = root;
        permissions = "R";
        rules = [
          {
            path = "/upload/";
            permissions = "CRUD";
          }
        ];
        users = [
          {
            username = "tsssni";
            password = "{bcrypt}$2b$10$9BLg/F5nkUzEJXTaiVgbQuF5fztgkyUzy62E9GRnnijGrUo8.4nSm";
          }
        ];
      };
    };
  };

  systemd.services.webdav.serviceConfig = {
    StateDirectory = [
      "webdav/data"
      "webdav/data/upload"
    ];
    StateDirectoryMode = "2770";
    UMask = "0007";
  };
}
