{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.visual.font;
in {
	options.tsssni.visual.font = {
		enable = lib.mkEnableOption "tsssni.visual.font";
		packages = lib.mkOption {
			type = lib.types.listOf lib.types.package;
			default = with pkgs; [
				nerd-fonts.blex-mono
				noto-fonts
				noto-fonts-cjk-sans
				noto-fonts-color-emoji
			];
			example = lib.literalExpression "[ pkgs.nerd-fonts.blex-mono ]";
			description = ''
				font packages used by system
			'';
		};
		latinFont = lib.mkOption {
			type = lib.hm.types.fontType;
			default = {
				package = pkgs.nerd-fonts.blex-mono;
				name = "BlexMono Nerd Font";
				size = 12;
			};
			description = ''
				latin font
			'';
		};
	};

	config = lib.mkIf cfg.enable {
		home.packages = cfg.packages;
	};
}
