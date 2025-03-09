{
  pkgs
, ...
}:
{
	programs.fish.enable = true;

	users.users.deck = {
		name = "deck";
		home = "/home/deck";
		shell = pkgs.fish;
		extraGroups = [ "wheel" ];
		isNormalUser = true;
	};
}
