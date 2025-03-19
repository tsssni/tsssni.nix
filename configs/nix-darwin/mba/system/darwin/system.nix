{
  pkgs
, ...
}: 
{
	programs.zsh.enable = true;

	users.users.tsssni = {
		name = "tsssni";
		home = "/Users/tsssni";
		shell = pkgs.zsh;
	};

	system.stateVersion = 6;
}

