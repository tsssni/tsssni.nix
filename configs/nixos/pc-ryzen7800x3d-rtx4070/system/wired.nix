{ lib
, tsssni
, ... 
}:
{
  networking = {
    hostName = "tsssni-" + tsssni.host;
    hostId = "01145140";
		networkmanager.enable = true;
		proxy.default = "127.0.0.1:7890";
    useDHCP = lib.mkDefault true;
	};

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
}
