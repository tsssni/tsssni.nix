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
    ./packages.nix
    ./state-version.nix
    ./users.nix
  ];
}
