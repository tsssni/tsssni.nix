{
  config
, ...
}: 
{
	users.users.tsssni = {
		name = "tsssni";
		home = "/Users/tsssni";
		shell = config.tsssni.shell.shell.package;
	};

	system.stateVersion = 6;
}

