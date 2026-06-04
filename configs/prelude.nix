args: {
  pkgs,
  lib,
  ...
}:
let
  features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
  substituters = [
    "https://cache.nixos.org"
    "https://cache.nixos-cuda.org"
    "https://nix-community.cachix.org"
    "https://jovian.cachix.org"
    "https://tsssni.cachix.org"
  ];
  keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "jovian.cachix.org-1:8Vq4Txku6VZIRhYrHYki3Ab9XHJRoWmdYqMqj4rB/Uc="
    "tsssni.cachix.org-1:LMXr408+oLBpr9IkXMxT6L6F3lJuVPvev8oTf9zQnB0="
  ];
  packages = with pkgs; [
    nix
    nh
  ];

  systemCfg = {
    nix = {
      package = pkgs.nix;
      nixPath = [
        "nixpkgs=${args.inputs.nixpkgs}"
      ];
      settings = {
        experimental-features = features;
        substituters = substituters;
        trusted-substituters = substituters;
        trusted-public-keys = keys;
      };
      gc = {
        automatic = true;
        options = "-d";
      };
      optimise.automatic = true;
    };

    nixpkgs = {
      system = args.system;
      config = args.config;
      overlays =
        with args.inputs;
        (
          [
            (final: prev:
              let
                master = import nixpkgs-master {
                  inherit (args) system;
                  config = final.config;
                };
              in
              {
                agenix = agenix.packages.${args.system}.default;
                inherit (master) claude-code;
              })
          ]
          ++ (import ../pkgs lib)
        );
    };

    environment.systemPackages = packages;
  };

  standloneCfg = removeAttrs systemCfg [ "environment" ] // {
    nix = removeAttrs systemCfg.nix [ "optimise" ];
    home.packages = packages;
  };
in
if (args.distro == "home") then standloneCfg else systemCfg
