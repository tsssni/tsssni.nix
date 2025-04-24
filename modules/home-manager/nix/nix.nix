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
			settings = {
				experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
				substituters = [
					"https://cache.nixos.org"
					"https://cache.garnix.io"
				];
				trusted-substituters = [
					"https://cache.garnix.io" 
				];
				trusted-public-keys = [
					"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
					"cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
				];
			};
		};
		nixpkgs = {
			system = tsssni.system;
			config.allowUnfree = true;
		};
	};
}
