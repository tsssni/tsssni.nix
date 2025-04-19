{
  tsssni
, ...
}:
{
	wsl = {
		enable = true;
		defaultUser = "wsl";
		startMenuLaunchers = true;
		wslConf.network.hostname = tsssni.func;
	};
}
