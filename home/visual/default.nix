{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    wl-clipboard
  ];

  imports = [
    ./hyprland.nix
    ./ags.nix
    ./theme.nix
    ./yoasobi.nix
  ];
}
