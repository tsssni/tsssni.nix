{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.services.sing-box;
in
{
	options.tsssni.services.sing-box.enable = lib.mkEnableOption "tsssni.sing-box";

	config = lib.mkIf cfg.enable {
		age.secrets = {
			"sbx-passwd".file = ./config/sbx-passwd.age;
			"sbx-server".file = ./config/sbx-server.age;
		};
		services.sing-box = {
			enable = true;
			settings = {
				dns = {
					servers = [
						{
							tag = "cf";
							address = "tls://1.1.1.1";
						}
						{
							tag = "local";
							address = "223.5.5.5";
							detour = "direct";
						}
						{
							tag = "remote";
							address = "fakeip";
						}
					];
					rules = [
						{
							rule_set = "geosite-cn";
							server = "local";
						}
						{
							outbound = "any";
							server = "local";
						}
						{
							query_type = [
								"A"
								"AAAA"
							];
							server = "remote";
						}
					];
					fakeip = {
						enabled = true;
						inet4_range = "198.18.0.0/15";
						inet6_range = "fc00::/18";
					};
					strategy = "ipv4_only";
					independent_cache = true;
				};
				inbounds = [
					{
						type = "mixed";
						tag = "mixed-in";
						listen = "127.0.0.1";
						listen_port = 7890;
						sniff = true;
					}
				];
				outbounds = [
					{
						type = "selector";
						tag = "select";
						outbounds = [
							"wired"
							"direct"
						];
						default = "wired";
						interrupt_exist_connections = false;
					}
					{
						type = "hysteria2";
						tag = "wired";
						server._secret = config.age.secrets."sbx-server".path;
						server_port = 8080;
						up_mbps = 100;
						down_mbps = 100;
						password._secret = config.age.secrets."sbx-passwd".path;
						tls = {
							enabled = true;
							server_name._secret = config.age.secrets."sbx-server".path;
							utls.enabled = true;
						};
					}
					{
						type = "direct";
						tag = "direct";
					}
					{
						type = "dns";
						tag = "dns";
					}
				];
				route = {
					rules = [
						{
							protocol = "dns";
							outbound = "dns";
						}
						{
							ip_is_private = true;
							outbound = "direct";
						}
						{
							port = 22;
							outbound = "direct";
						}
						{
							port = 2222;
							outbound = "direct";
						}
						{
							rule_set = [
								"geoip-cn"
								"geosite-cn"
							];
							outbound = "direct";
						}
						{
							domain_keyword = [
								"bilibili"
								"zju"
								"cc98"
							];
							outbound = "direct";
						}
					];
					rule_set = [
						{
							type = "local";
							tag = "geosite-cn";
							format = "binary";
							path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
						}
						{
							type = "local";
							tag = "geoip-cn";
							format = "binary";
							path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
						}
					];
					auto_detect_interface = true;
				};
			};
		};
	};
}
