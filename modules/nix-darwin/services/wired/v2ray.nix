{
	config
, lib
, pkgs
, ...
}:
{
	options = {
		services.v2ray = {
			enable = lib.mkOption {
				type = lib.types.bool;
				default = false;
				description = ''
					Whether to run v2ray server.

					Either `configFile` or `config` must be specified.
				'';
			};

			package = lib.mkPackageOption pkgs "v2ray" { };

			configFile = lib.mkOption {
				type = lib.types.nullOr lib.types.str;
				default = null;
				example = "/etc/v2ray/config.json";
				description = ''
					The absolute path to the configuration file.

					Either `configFile` or `config` must be specified.

					See <https://www.v2fly.org/en_US/v5/config/overview.html>.
				'';
			};

			config = lib.mkOption {
				type = lib.types.nullOr (lib.types.attrsOf lib.types.unspecified);
				default = null;
				example = {
					inbounds = [{
						port = 1080;
						listen = "127.0.0.1";
						protocol = "http";
					}];
					outbounds = [{
						protocol = "freedom";
					}];
				};
				description = ''
					The configuration object.

					Either `configFile` or `config` must be specified.

					See <https://www.v2fly.org/en_US/v5/config/overview.html>.
				'';
			};
		};

	};

	config = let
		cfg = config.services.v2ray;
		configFile = if cfg.configFile != null
		then cfg.configFile
		else pkgs.writeTextFile {
			name = "v2ray.json";
			text = builtins.toJSON cfg.config;
			checkPhase = ''
				${cfg.package}/bin/v2ray test -c $out
			'';
		};

	in lib.mkIf cfg.enable {
		assertions = [
			{
				assertion = (cfg.configFile == null) != (cfg.config == null);
				message = "Either but not both `configFile` and `config` should be specified for v2ray.";
			}
		];

		launchd.agents.v2ray = {
			serviceConfig = {
				ProgramArguments = [ "${cfg.package}/bin/v2ray" "run" "-c" "${configFile}" ];
				KeepAlive = true;
				RunAtLoad = true;
			};
		};
	};
}
