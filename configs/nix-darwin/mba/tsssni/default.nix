{
  pkgs,
  ...
}:
{
  home = {
    username = "tsssni";
    homeDirectory = "/Users/tsssni";
    stateVersion = "24.11";
    packages = with pkgs; [
      # tev
    ];
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel.git.enable = true;
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
      mygo.enable = true;
      mujica.enable = true;
    };
    wired = {
      ssh.enable = true;
      transfer.enable = true;
      vpn.enable = true;
    };
  };
}
