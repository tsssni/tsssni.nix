{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    git 
    micromamba
  ];

  imports = [
    ./git.nix
  ];
}
