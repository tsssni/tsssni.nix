{
  pkgs,
  ...
}:
{
  tsssni.devel.git.enable = true;

  home.packages = with pkgs; [
    jetbrains.rider
  ];
}
