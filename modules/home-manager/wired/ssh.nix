{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.ssh;
in with lib; {
	options.tsssni.ssh = {
		enable = mkEnableOption "tsssni.ssh";
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
