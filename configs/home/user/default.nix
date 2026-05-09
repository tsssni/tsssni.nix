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
      literal = {
        enable = true;
        input.type = "ibus";
      };
      science.enable = true;
      version.enable = true;
    };
    intef = {
      shell.enable = true;
      terminal.enable = true;
    };
    nixvim.enable = true;
  };
}
