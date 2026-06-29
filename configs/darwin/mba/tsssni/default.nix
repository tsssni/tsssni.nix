{ ... }:
{
  home = {
    username = "tsssni";
    homeDirectory = "/Users/tsssni";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    intef = {
      shell.enable = true;
      terminal.enable = true;
    };
    nixvim.enable = true;
    devel = {
      aesth = {
        enable = true;
        consume = true;
      };
      intelli.enable = true;
      literal = {
        enable = true;
        font.emojiFont.package = null;
        input.type = "squirrel";
      };
      science.enable = true;
      version = {
        enable = true;
        name = "tsssni";
        email = "dingyongyu2002@foxmail.com";
      };
      wired = {
        enable = true;
        tunnel = true;
      };
    };
  };
}
