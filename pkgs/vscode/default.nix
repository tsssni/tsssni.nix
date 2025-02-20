{
  pkgs
, ...
}:
with pkgs; {
	Eldritch.eldritch = callPackage ./eldritch.nix {};
}
