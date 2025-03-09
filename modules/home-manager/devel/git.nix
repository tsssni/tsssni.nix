{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.git;
in with lib; {
	options.tsssni.git = {
		enable = mkEnableOption "tsssni.git";
	};

	config = mkIf cfg.enable {
		programs.git = {
			enable = true;
			userName = "tsssni";
			userEmail = "dingyongyu2002@foxmail.com";
			extraConfig = {
				credential.helper = "store";
				rebase.pull = "rebase";
			};
		};
	};
}
