{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.nixvim;
in {
	programs.nixvim = lib.mkIf cfg.enable {
		plugins.auto-session.enable = true;
	};
}
