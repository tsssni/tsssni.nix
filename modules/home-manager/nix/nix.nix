{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.nix.nix;
in {
	options.tsssni.nix.nix = {
		enable = lib.mkEnableOption "tsssni.nix.nix";
	};

	config = lib.mkIf cfg.enable {
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
	};
}
