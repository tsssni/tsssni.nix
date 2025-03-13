{
  pkgs
, lib
, config
, ...
}:
let
	cfg = config.tsssni.services.sing-box;
in with lib; {
	options.tsssni.services.sing-box.enable = mkEnableOption "tsssni.sing-box";

	config = mkIf cfg.enable {
		age.secrets = {
			"sbx-passwd" = {
				file = ./config/sbx-passwd.age;
				mode = "440";
			};
			"sbx-server" = {
				file = ./config/sbx-server.age;
				mode = "440";
			};
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
							rule_set = "geosite-steam@cn";
							server = "local";
						}
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
						type = "tun";
						address = [
							"172.19.0.1/30"
							"fdfe:dcba:9876::1/126"
						];
						auto_route = true;
						strict_route = false;
					}
				];
				outbounds = [
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
						};
					}
					{
						type = "direct";
						tag = "direct";
					}
				];
				route = {
					rules = [
						{
							action = "sniff";
						}
						{
							protocol = "dns";
							action = "hijack-dns";
						}
						{
							ip_is_private = true;
							outbound = "direct";
						}
						{
							rule_set = [
								"geosite-steam@cn"
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
							tag = "geosite-steam@cn";
							format = "binary";
							path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-steam@cn.srs";
						}
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
