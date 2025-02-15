{
  tsssni
, ...
}:
{
  nixpkgs = {
    hostPlatform = tsssni.system;
    config.allowUnfree = true;
  };
}
