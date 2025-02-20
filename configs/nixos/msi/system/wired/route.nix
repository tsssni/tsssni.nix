{ ... }:
{
	services.create_ap = {
		enable = true;
		settings = {
			INTERNET_IFACE = "enp12s0";
			WIFI_IFACE = "wlp13s0";
			SSID = "tsssni.wifi";
			PASSPHRASE = "351609538";
		};
	};
	boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 80 443 ];
		allowedUDPPorts = [ 53 67 68 ];
		extraCommands = ''
			iptables -t mangle -N V2RAY
			iptables -t mangle -A V2RAY -d 127.0.0.1/32 -j RETURN
			iptables -t mangle -A V2RAY -d 10.0.0.0/8 -j RETURN
			iptables -t mangle -A V2RAY -d 172.16.0.0/12 -j RETURN
			iptables -t mangle -A V2RAY -d 192.168.0.0/16 -p tcp -j RETURN
			iptables -t mangle -A V2RAY -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
			iptables -t mangle -A V2RAY -d 224.0.0.0/4 -j RETURN
			iptables -t mangle -A V2RAY -d 255.255.255.255/32 -j RETURN
			iptables -t mangle -A V2RAY -p tcp -j TPROXY --on-ip 127.0.0.1 --on-port 12345 --tproxy-mark 1
			iptables -t mangle -A V2RAY -p udp -j TPROXY --on-ip 127.0.0.1 --on-port 12345 --tproxy-mark 1
			iptables -t mangle -A PREROUTING -j V2RAY
		'';
	};
}
