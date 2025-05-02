{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.visual.font;
in with lib; {
	options.tsssni.visual.font = {
		enable = mkEnableOption "tsssni.visual.font";
		packages = mkOption {
			type = types.listOf types.package;
			default = with pkgs; [
				nerd-fonts.blex-mono
				noto-fonts
				noto-fonts-cjk-sans
				noto-fonts-color-emoji
			];
			example = literalExpression "[ pkgs.nerd-fonts.blex-mono ]";
			description = ''
				font packages used by system
			'';
		};
		latinFont = mkOption {
			type = hm.types.fontType;
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

	config = mkIf cfg.enable {
		home.packages = cfg.packages;
	};
}
