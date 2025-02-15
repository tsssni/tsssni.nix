{
  tsssni
, ...
}:
{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
    optimise.automatic = true;
  };

  nixpkgs = {
    hostPlatform = tsssni.system;
    config.allowUnfree = true;
  };
}
