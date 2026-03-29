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
    devel = {
      intelli.enable = true;
      script.enable = true;
      version.enable = true;
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
        type = "ibus";
      };
      theme.tui.enable = true;
    };
  };
}
