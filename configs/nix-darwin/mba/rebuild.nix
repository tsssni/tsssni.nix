{
  inputs
, tsssni
, func
}:
import ../rebuild.nix {
	inherit inputs tsssni func;
	system = "aarch64-darwin";
}
