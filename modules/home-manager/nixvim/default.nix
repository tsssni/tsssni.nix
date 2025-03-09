{
  pkgs
, tsssni
, lib
, config
, ...
}:
let
	cfg = config.tsssni.nixvim;
in with lib; {
	imports = [
		./compiler.nix
		./filesystem.nix
		./session.nix
		./statusline.nix
		./terminal.nix
		./vimoption.nix
		./visual.nix
		./window.nix
	];

	options.tsssni.nixvim = {
		enable = mkEnableOption "tsssni.nixvim"; 
		colorscheme = mkOption {
			type = types.str;
			default = "default";
			example = "cyyber";
			description = "colorscheme used in current installation";
		};
	};

	config = mkIf cfg.enable {
		programs.nixvim = {
			enable = true;
			defaultEditor = true;
			nixpkgs.useGlobalPackages = true;
			colorscheme = cfg.colorscheme;
			extraPlugins = []
			++ (with pkgs.vimPlugins; [ 
				nvim-web-devicons
				lush-nvim
				tokyonight-nvim
				sonokai
			]) 
			++ (with tsssni.pkgs.vimPlugins; [
				cyyber-nvim
				eldritch-nvim
				incline-nvim
			]);
		};
	};
}
