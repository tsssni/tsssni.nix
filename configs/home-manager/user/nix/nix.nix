{
  pkgs
, tsssni
, ...
}:
{
	home.packages = with pkgs; [
		nix
	];

	nix = {
		package = pkgs.nix;
		settings = {
			experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
			substituters = [
				"https://cache.garnix.io"
			];
			trusted-public-keys = [
				"cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
			];
		};
	};

	nixpkgs = {
		system = tsssni.system;
		config.allowUnfree = true;
	};
}
