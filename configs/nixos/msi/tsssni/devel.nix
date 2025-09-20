{
  pkgs,
  ...
}:
{
  tsssni.devel.git.enable = true;

  home.packages = with pkgs; [
    perf
    hotspot
  ];
}
