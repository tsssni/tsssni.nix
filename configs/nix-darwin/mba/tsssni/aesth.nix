{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gimp3
  ];
}
