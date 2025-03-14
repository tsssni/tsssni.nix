{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.fastfetch;
	isNixOS = cfg.logo == "tsssni-nixos";
	isDarwin = cfg.logo == "tsssni-nix-darwin";
in with lib; {
	options.tsssni.fastfetch = {
		enable = mkEnableOption "tsssni.fastfetch";
		logo = mkOption {
			type = types.str;
			default = "tsssni-nixos";
			example = "tsssni-nixos";
			description = "logo used by fastfetch";
		};
	};

	config = mkIf cfg.enable {
		programs.fastfetch = {
			enable = true;
			settings = {
				logo = if false then ""
				else if isNixOS then {
					type = "file";
					source = "${config.home.homeDirectory}/.config/fastfetch/nix-small.txt";
					color = {
						"1" = "light_blue";
						"2" = "light_cyan";
					};
				}
				else if isDarwin then {
					type = "kitty";
					source = "${config.home.homeDirectory}/.config/fastfetch/nix-darwin.png";
					width = 16;
				}
				else if (cfg.logo != "") then {
					type = cfg.logo;
				}
				else {
					type = "small";
				};

				modules = []
				++ lib.optionals isDarwin [
					{
						type = "break";
					}
				]
				++ [
					{
						type = "os";
						format = "{2} {9}";
						key = "󱄅 系";
						keyColor = "cyan";
					}
					{
						type = "kernel";
						format = "{1} {2}";
						key = " 核";
						keyColor = "light_yellow";
					}
					{
						type = "shell";
						format = "{3} {4}";
						key = " 壳";
						keyColor = "light_green";
					}
					{
						type = "terminal";
						format = "{5} {6}";
						key = " 端";
						keyColor = "light_magenta";
					}
					{
						type = "packages";
						format = "Nix {9}";
						key = "󰏗 包";
						keyColor = "light_blue";
					}
					{
						type = "opengl";
						format = "{5} {4}";
						key = "󰡷 图";
						keyColor = "light_cyan";
					}
					{
						type = "vulkan";
						format = "Vulkan {2}";
						key = "󰈸 火";
						keyColor = "light_white";
					}
				];
			};
		};

		home = {
			file.".config/fastfetch" = {
				source = ./config/fastfetch;
				recursive = true;
			};
		};
	};
}
