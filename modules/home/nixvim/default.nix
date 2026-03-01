{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nixvim;
in
{
  imports = [
    ./compiler.nix
    ./filesystem.nix
    ./statusline.nix
    ./option.nix
    ./visual.nix
  ];

  options.tsssni.nixvim = {
    enable = lib.mkEnableOption "tsssni.nixvim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;
      colorscheme = "plana";
      extraPlugins = with pkgs.vimPlugins; [ plana-nvim ];
    };
  };
}
