{
  config
, ...
}:
{
	users.users.wsl = {
		name = "wsl";
		home = "/home/wsl";
		shell = config.tsssni.shell.shell.package;
		hashedPassword = "$y$j9T$VvZ/yXQDMqfPz.CviVzJy/$Tq6nK6AzUPppFUjzenqKmkRZpVT4dZM2gs2YpadzdaB";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
	};
}
