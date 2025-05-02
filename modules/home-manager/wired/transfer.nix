{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.transfer;
in with lib; {
	options.tsssni.wired.transfer = {
		enable = mkEnableOption "tsssni.wired.transfer";
	};

	config = mkIf cfg.enable {
		home.packages = with pkgs; [
			curl
			wget
		];
	};
}
