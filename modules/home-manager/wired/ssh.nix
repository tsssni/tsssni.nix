{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.wired.ssh;
in with lib; {
	options.tsssni.wired.ssh = {
		enable = mkEnableOption "tsssni.wired.ssh";
	};

	config = mkIf cfg.enable {
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
