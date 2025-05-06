{
  tsssni
, ...
}:
{
	tsssni.wired = {
		network = {
			enable = true;
			hostName = tsssni.func;
		};
		sing-box.enable = true;
		ssh.enable = true;
	};
}
