{ ... }:
{
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
			Keynote = 409183694;
			Pages = 409201541;
			Numbers = 409203825;
		};
	};
}
