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
    ./session.nix
    ./statusline.nix
    ./terminal.nix
    ./vimoption.nix
    ./visual.nix
    ./window.nix
  ];

  options.tsssni.nixvim = {
    enable = lib.mkEnableOption "tsssni.nixvim";
    colorscheme = lib.mkOption {
      type = lib.types.str;
      default = "plana";
      example = "plana";
      description = "colorscheme used in current installation";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;
      colorscheme = cfg.colorscheme;
      extraPlugins = with pkgs.vimPlugins; [
        incline-nvim
        nvim-web-devicons
        lush-nvim
        tokyonight-nvim
        bluloco-nvim
        sonokai
        plana-nvim
        cyyber-nvim
        eldritch-nvim
      ];
    };
  };
}
