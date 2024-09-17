{ ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
  imports = [
    ./compiler.nix
    ./filesystem.nix
    ./session.nix
    ./statusline.nix
    ./terminal.nix
    ./vimoption.nix
    ./visual.nix
    ./window.nix
  ];
}
