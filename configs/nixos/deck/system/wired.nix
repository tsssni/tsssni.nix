{ ... }:
{
  tsssni.infra = {
    crypto.enable = true;
    wired = {
      enable = true;
      host = "deck";
      tunnel = true;
    };
  };
}
