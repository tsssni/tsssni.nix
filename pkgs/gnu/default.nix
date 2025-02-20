{
  pkgs
, ...
}:
with pkgs;
(
	{}
	// (callPackage ./prefixed {})
)
