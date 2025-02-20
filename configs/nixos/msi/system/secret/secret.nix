{
  tsssni
, inputs
, ...
}:
{
	environment.systemPackages = [
		inputs.agenix.packages.${tsssni.system}.default
	];
}
