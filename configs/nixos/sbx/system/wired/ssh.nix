{
  lib
, ...
}:
{
	services.openssh = {
		enable = true;
		ports = [ 2222 ];
		settings = {
		  PasswordAuthentication = false;
		  PermitRootLogin = lib.mkForce "prohibit-password";
		};
	};
}
