{ pkgs, ... }:
{
  home.packages = with pkgs; [ elvish ];

	home = {
		file.".config/elvish" = {
			source = ./config/elvish;
			recursive = true;
		};
	};
}