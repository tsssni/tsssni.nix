{ ... }:
let
	domain = "tsssni.top";
in {
	security.acme = {
		acceptTerms = true;
		defaults.email = "dingyongyu2002@foxmail.com";
		certs."${domain}" = {
			webroot = "/var/lib/acme/.challenges";
			group = "nginx";
		};
	};
	services.nginx = {
		enable = true;
		virtualHosts = {
			"${domain}" = {
				forceSSL = true;
				enableACME = true;
				locations."/".root = "/var/www";
			};
			"acmechallenge.${domain}".locations = {
				"/.well-known/acme-challenge".root = "/var/lib/acme/.challenges";
				"/".return = "301 https://$host$request_uri";
			};
		};
	};
}
