{
  tsssni,
  ...
}:
{
  tsssni.wired = {
    network = {
      enable = true;
      hostName = tsssni.func;
    };
    ssh.enable = true;
  };
}
