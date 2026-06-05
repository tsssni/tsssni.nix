{
  lib,
  config,
  ...
}:
let
  root = config.services.filebrowser.settings.root;
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

  services.filebrowser = {
    enable = true;
    settings.address = "0.0.0.0";
  };

  systemd = {
    services.filebrowser.serviceConfig.UMask = lib.mkForce "0007";
    tmpfiles.settings.filebrowser.${root}.d.mode = lib.mkForce "2770";
  };
}
