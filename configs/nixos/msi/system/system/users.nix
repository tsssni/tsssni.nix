{
  config
, ...
}:
{
	users.users.tsssni = {
		name = "tsssni";
		home = "/home/tsssni";
		shell = config.tsssni.shell.shell.package;
		hashedPassword = "$y$j9T$mzXj7DKn7uD9EWbb.EdTo0$Yix0Fy713KpDwzwYF4K3yYAWhMlyR7Acy8SU81lx7Q5";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
	};
}
