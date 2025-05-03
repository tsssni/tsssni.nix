{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.vpn;
in {
	options.tsssni.wired.vpn = {
		enable = lib.mkEnableOption "tsssni.wired.vpn";
	};

	config = lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			wireguard-tools
		];
	};
}
