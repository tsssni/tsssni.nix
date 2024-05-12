{ ... }:
{
  programs.kitty.enable = true;

	home = {
		file.".config/kitty" = {
			source = ./config/kitty;
			recursive = true;
		};
	};
}
