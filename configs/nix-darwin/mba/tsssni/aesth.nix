{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    tev
  ];
}
