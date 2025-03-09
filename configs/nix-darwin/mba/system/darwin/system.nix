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

	ids.gids.nixbld = 30000;

	system.stateVersion = 6;
}

