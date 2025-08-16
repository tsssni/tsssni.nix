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
      shell = config.tsssni.shell.shell.package;
      uid = 501;
    };
  };

  system = {
    primaryUser = "tsssni";
    stateVersion = 6;
  };
}
