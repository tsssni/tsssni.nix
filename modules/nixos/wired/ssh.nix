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
		services.openssh.enable = true;
		programs.ssh.startAgent = true;
	};
}
