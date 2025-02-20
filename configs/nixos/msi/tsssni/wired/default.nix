{
  pkgs
, ...
}:
{
	home.packages = with pkgs; [ 
		wireguard-tools
		wget
		curl
	];

	imports = [
		./firefox.nix
		./ssh.nix
	];
}
