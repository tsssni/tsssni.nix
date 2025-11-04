{
  config,
  ...
}:
{
  users = {
    knownUsers = [ "tsssni" ];
    users.tsssni = {
      name = "tsssni";
      home = "/Users/tsssni";
      shell = config.tsssni.shell.package;
      uid = 501;
    };
  };

  system = {
    primaryUser = "tsssni";
    stateVersion = 6;
  };

  tsssni = {
    shell.enable = true;
    secret.enable = true;
    wired.sing-box.enable = true;
  };
}
