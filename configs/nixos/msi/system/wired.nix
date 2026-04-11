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
}
