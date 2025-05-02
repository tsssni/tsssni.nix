{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.ssh;
in {
	options.tsssni.wired.ssh = {
		enable = lib.mkEnableOption "tsssni.wired.ssh";
	};

	config = lib.mkIf cfg.enable {
		programs.ssh = {
			enable = true;
			forwardAgent = true;
			addKeysToAgent = "yes";
			hashKnownHosts = true;
			includes = [
				"~/.ssh/config.d/*"
			];
		};
	};
}
