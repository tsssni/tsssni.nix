{ ... }:
{
  home = {
    username = "tsssni";
    homeDirectory = "/Users/tsssni";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel = {
      env.enable = true;
      git.enable = true;
      intelli.enable = true;
    };
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      shell.enable = true;
      terminal.enable = true;
    };
    visual = {
      color.enable = true;
      file.enable = true;
      font.enable = true;
      ime = {
        enable = true;
        type = "squirrel";
      };
      media.enable = true;
    };
    wired.ssh.enable = true;
  };
}
