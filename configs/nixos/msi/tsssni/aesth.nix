{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    blender
    gimp3
    tev
  ];
}
