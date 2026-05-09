{ ... }:
{
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    intef.shell.enable = true;
    nixvim.enable = true;
    devel = {
      literal.enable = true;
      version = {
        enable = true;
        name = "tsssni";
        email = "dingyongyu2002@foxmail.com";
      };
      wired = {
        enable = true;
        tunnel = true;
      };
    };
  };
}
