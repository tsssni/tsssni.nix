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
		proxy.default = "127.0.0.1:7890";
		useDHCP = lib.mkDefault true;
	};
}
