{ ... }:
{
	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
			auto-optimise-store = true;
		};
	};
}
