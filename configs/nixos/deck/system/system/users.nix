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
		hashedPassword = "$6$C2DsafvrEGoy3g8A$gV9LFctSY7A1WHJk8sjwY6hu04zTldhHH6LWayvUBSm3D8s9oW//jqbVDv0VVD00BcH8QScp4leXzjmSqvieT.";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
	};
}
