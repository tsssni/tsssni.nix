{
  tsssni
, ...
}:
{
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
		auto-optimise-store = true;
		substituters = [
			"https://cache.garnix.io"
		];
		trusted-public-keys = [
			"cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
		];
	};
	nixpkgs = {
		hostPlatform = tsssni.system;
		config.allowUnfree = true;
	};
}
