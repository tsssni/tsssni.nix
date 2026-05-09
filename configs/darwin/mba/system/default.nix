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
      shell = config.tsssni.infra.shell.package;
      uid = 501;
    };
  };

  system = {
    primaryUser = "tsssni";
    stateVersion = 6;
  };

  tsssni.infra = {
    shell.enable = true;
    crypto.enable = true;
  };
}
