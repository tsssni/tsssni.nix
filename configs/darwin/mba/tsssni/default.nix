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
      intelli.enable = true;
      script.enable = true;
      version = {
        enable = true;
        name = "tsssni";
        email = "dingyongyu2002@foxmail.com";
      };
    };
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      shell.enable = true;
      terminal.enable = true;
    };
    visual = {
      ime = {
        enable = true;
        type = "squirrel";
      };
      media.enable = true;
      theme.tui.enable = true;
    };
    wired.ssh.enable = true;
  };
}
