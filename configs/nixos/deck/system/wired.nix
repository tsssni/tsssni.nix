{ ... }:
{
  tsssni.infra = {
    crypto = {
      enable = true;
      passwd = ../../../../assets/infra/passwd.age;
    };
    wired = {
      enable = true;
      host = "deck";
      tunnel = true;
    };
  };
}
