{
  pkgs
, config
, lib
, tsssni
, ...
}:

let
	cfg = config.services.sing-box;
	settingsFormat = pkgs.formats.json {};
	inherit (tsssni.lib.utils pkgs) genJqSecretsReplacementSnippet;
in {
	options.services.sing-box = {
		enable = lib.mkEnableOption (lib.mdDoc "sing-box universal proxy platform");
		package = lib.mkPackageOption pkgs "sing-box" { };
		settings = lib.mkOption {
			type = lib.types.submodule {
				freeformType = settingsFormat.type;
			};
			default = {};
			description = ''
				The sing-box configuration, see https://sing-box.sagernet.org/configuration/ for documentation.

				Options containing secret data should be set to an attribute set
				containing the attribute `_secret` - a string pointing to a file
				containing the value the option should be set to.
			'';
		};
	};

	config = lib.mkIf cfg.enable {
		launchd.agents.sing-box =
		let
			script = ''
				${genJqSecretsReplacementSnippet cfg.settings "/tmp/sing-box/config.json"}
				${lib.getExe cfg.package} -C /tmp/sing-box run
			'';
		in {
			serviceConfig = {
				Program = toString (pkgs.writeShellScript "sing-box-wrapper" script);
				Label = "org.sagernet.sing-box";
				KeepAlive = true;
				RunAtLoad = true;
				StandardOutPath = "/tmp/sing-box/info.log";
				StandardErrorPath = "/tmp/sing-box/error.log";
			};
		};
	};
}
