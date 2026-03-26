{ ... }:
{
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel.version.enable = true;
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      shell.enable = true;
    };
    visual = {
      color.enable = true;
      font.enable = true;
    };
    wired.ssh.enable = true;
  };
}
