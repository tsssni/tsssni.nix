{
  config
, ...
}:
{
	age.secrets = {
		"sbx-name".file = ./config/sbx-name.age;
		"sbx-passwd".file = ./config/sbx-passwd.age;
		"sbx-server".file = ./config/sbx-server.age;
		"sbx-cert".file = ./config/sbx-cert.age;
		"sbx-key".file = ./config/sbx-key.age;
	};
	services.sing-box = {
		enable = true;
		settings = {
			inbounds = [
				{
					type = "hysteria2";
					listen = "::";
					listen_port = 8080;
					up_mbps = 100;
					down_mbps = 100;
					users = [
						{
							name._secret = config.age.secrets."sbx-name".path;
							password._secret = config.age.secrets."sbx-passwd".path;
						}
					];
					tls = {
						enabled = true;
						server_name._secret = config.age.secrets."sbx-server".path;
						certificate_path._secret = config.age.secrets."sbx-cert".path;
						key_path._secret = config.age.secrets."sbx-key".path;
					};
				}
			];
		};
	};
}
