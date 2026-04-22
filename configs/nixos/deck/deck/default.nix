{ ... }:
{
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel.version = {
      enable = true;
      name = "tsssni";
      email = "dingyongyu2002@foxmail.com";
    };
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      shell.enable = true;
    };
    visual.theme.tui.enable = true;
    wired.ssh.enable = true;
  };
}
