{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python3.withPackages (python-pkgs: [
      python-pkgs.psutil
    ]))
  ];
}
