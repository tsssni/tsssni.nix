{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nixvim;
  lib' = import ../../../lib { inherit lib; };
in
{
  imports = lib'.importDir ./.;

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
