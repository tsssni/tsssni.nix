{ ... }:
{
  home = {
    username = "tsssni";
    homeDirectory = "/home/tsssni";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  imports = [ 
    ./devel
    ./nixvim
    ./shell
    ./visual
    ./wired
  ];
}
