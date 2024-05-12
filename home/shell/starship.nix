{ ... }:
{
  programs.starship.enable = true;

	home = {
		file.".config/starship" = {
			source = ./config/starship;
			recursive = true;
		};
	};
}
