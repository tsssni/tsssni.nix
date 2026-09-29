{ ... }:
{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "24.11";
  };

  tsssni = {
    home.standalone = true;
    devel = {
      intelli.enable = true;
      literal = {
        enable = true;
        input.type = "ibus";
      };
      version.enable = true;
    };
    intef = {
      shell.enable = true;
      terminal.enable = true;
    };
    nixvim.enable = true;
  };
}
