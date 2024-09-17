{ 
  pkgs
, ...
}:
with pkgs; {
  ggrep = callPackage ./ggrep.nix {};
  gmake = callPackage ./gmake.nix {};
  gsed = callPackage ./gsed.nix {};
}
