{ ... }:
{
  tsssni.infra = {
    crypto = {
      enable = true;
      passwd = ../../../../assets/infra/passwd.age;
      domains = [
        "tsssni.top"
        "tsssni.biz"
      ];
    };
    wired = {
      enable = true;
      host = "deck";
      tunnel = true;
    };
  };
}
