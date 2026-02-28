{ ... }:
{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    home.standalone = true;
    devel.intelli.enable = true;
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      prompt.enable = true;
      shell.enable = true;
      terminal.enable = true;
    };
    visual = {
      color.enable = true;
      font.enable = true;
      ime = {
        enable = true;
        type = "ibus";
      };
    };
  };
}
