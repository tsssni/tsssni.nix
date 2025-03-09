{
  lib
, tsssni
, ...
}:
{
	config = lib.mkIf (tsssni.distro == "home-manager") {
		nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
		nixpkgs = {
			system = tsssni.system;
			config.allowUnfree = true;
		};
	};
}
