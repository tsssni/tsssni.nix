{
  lib
, ...
}:
{
  services.nix-daemon.enable = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
    optimise.automatic = true;
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-darwin";
    config.allowUnfree = true;
  };
}
