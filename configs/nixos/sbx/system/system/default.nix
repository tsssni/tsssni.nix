{
  modulesPath
, ...
}:
{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
		./kernel.nix
		./loader.nix
		./loctime.nix
		./state-version.nix
		./users.nix
	];
}
