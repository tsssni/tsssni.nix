{ ... }:
{
	programs.ssh = {
		enable = true;
		forwardAgent = true;
		addKeysToAgent = "yes";
		hashKnownHosts = true;
		includes = [
			"~/.ssh/config.d/*"
		];
	};
}
