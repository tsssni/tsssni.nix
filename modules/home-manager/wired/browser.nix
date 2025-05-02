{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.browser;
in with lib; {
	options.tsssni.wired.browser = {
		enable = mkEnableOption "tsssni.wired.browser";
	};

	config = mkIf cfg.enable {
		programs.firefox.enable = true;
	};
}
