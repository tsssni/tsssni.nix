{ ... }:
{
	home = {
		username = "user";
		homeDirectory = "/home/user";
		stateVersion = "24.11";
	};

	programs.home-manager.enable = true;

	imports = [
		./nixvim
	];
}
