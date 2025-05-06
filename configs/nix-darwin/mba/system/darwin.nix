{
  config
, ...
}:
{
	users = {
		knownUsers = [ "tsssni" ];
		users.tsssni = {
			name = "tsssni";
			home = "/Users/tsssni";
			shell = config.tsssni.shell.shell.package;
			uid = 501;
		};
	};

	homebrew = {
		enable = true;
		onActivation = {
			cleanup = "uninstall";
			autoUpdate = true;
			upgrade = true;
		};
		casks = [
			"wpsoffice"
		];
		masApps = {
			Xcode = 497799835;
			Keynote = 409183694;
			Pages = 409201541;
			Numbers = 409203825;
		};
	};

	system.stateVersion = 6;
}
