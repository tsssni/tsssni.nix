{ pkgs, ... }:
{
  programs = {
    ags.enable = true;
    bun.enable = true; # for ts config programming
  };

  home = {
    packages = with pkgs; [
      sass # for scss compilation
      lm_sensors # for temperature part of hardware monitor
      rocmPackages.rocm-smi # for amd rapheal monitor
      playerctl # for fetching music info
      imagemagick # for small music cover
    ];

    file.".config/ags" = {
      source = ./config/ags;
      recursive = true;
    };
  };
}
