{
  lib
, tsssni
, ... 
}:
{
	networking = {
		hostName = tsssni.func;
		hostId = "01145140";
		useDHCP = lib.mkDefault true;
		firewall.enable = false;
		networkmanager = {
			enable = true;
			wifi.backend = "iwd";
		};
	};
}
