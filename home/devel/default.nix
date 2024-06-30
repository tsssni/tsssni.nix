{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    git 
    micromamba
    clang
    (python3.withPackages (python-pkgs: [
      python-pkgs.psutil
    ]))
  ];

  imports = [
    ./git.nix
  ];
}
