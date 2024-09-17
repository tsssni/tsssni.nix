{ 
  pkgs
, ...
}:
with pkgs; {
  nerd-fonts.sf-mono-liga = callPackage ./sf-mono-liga.nix {};
}
