{ ... }:
{
  home = {
    username = "wsl";
    homeDirectory = "/home/wsl";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel.git.enable = true;
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      prompt.enable = true;
      shell.enable = true;
    };
    wired = {
      ssh.enable = true;
      transfer.enable = true;
    };
  };
}
