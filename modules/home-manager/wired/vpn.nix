{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.vpn;
in with lib; {
	options.tsssni.wired.vpn = {
		enable = mkEnableOption "tsssni.wired.vpn";
	};

	config = mkIf cfg.enable {
		home.packages = with pkgs; [
			wireguard-tools
		];
	};
}
