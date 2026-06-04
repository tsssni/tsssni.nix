{ ... }:
{
  home = {
    username = "banma";
    homeDirectory = "/home/banma";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    home.standalone = true;
    devel.version.enable = true;
    intef.shell.enable = true;
    nixvim.enable = true;
  };
}
