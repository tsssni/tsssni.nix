{
  pkgs
, lib
, config
, ...
}:
let
	 cfg = config.tsssni.shell.shell;
in {
	options.tsssni.shell.shell = {
		package = lib.mkPackageOption pkgs "nushell" {};
	};
}
