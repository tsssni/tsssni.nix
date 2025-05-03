{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.browser;
in {
	options.tsssni.wired.browser = {
		enable = lib.mkEnableOption "tsssni.wired.browser";
	};

	config = lib.mkIf cfg.enable {
		programs.firefox.enable = true;
	};
}
