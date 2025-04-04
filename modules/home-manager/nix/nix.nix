{
  pkgs
, lib
, tsssni
, ...
}:
{
	config = lib.optionalAttrs (tsssni.distro == "home-manager") {
		nix = {
			package = pkgs.nix;
			settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
		};
		nixpkgs = {
			system = tsssni.system;
			config.allowUnfree = true;
		};
	};
}
