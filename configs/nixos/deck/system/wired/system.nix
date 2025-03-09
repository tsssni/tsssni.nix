{
  lib
, tsssni
, ... 
}:
{
	networking = {
		hostName = tsssni.func;
		hostId = "01145140";
		networkmanager.enable = true;
		useDHCP = lib.mkDefault true;
		firewall.enable = false;
	};
}
