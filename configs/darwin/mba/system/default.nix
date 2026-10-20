{
  config,
  pkgs,
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
    tools.enable = false;
    stateVersion = 6;
  };

  environment.systemPackages = [
    (config.system.build.darwin-rebuild.overrideAttrs (prev: {
      buildPhase = builtins.replaceStrings [ "${pkgs.git}" ] [ "${pkgs.gitMinimal}" ] prev.buildPhase;
    }))
  ];

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
  };

  homebrew = {
    enable = true;
    casks = [ "macfuse@dev" ];
    onActivation.cleanup = "zap";
  };

  services.clouddrive.enable = true;

  tsssni.infra = {
    shell.enable = true;
    crypto = {
      enable = true;
      passwd = ../../../../assets/infra/passwd.age;
      domains = [
        "tsssni.top"
        "tsssni.biz"
      ];
    };
  };
}
