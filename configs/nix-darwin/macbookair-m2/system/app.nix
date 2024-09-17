{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mas
  ];
}
