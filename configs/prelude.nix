args:
{
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
      settings = {
        experimental-features = features;
        substituters = substituters;
        trusted-substituters = substituters;
        trusted-public-keys = keys;
        trusted-users = [ (if args.distro == "darwin" then "@admin" else "@wheel") ];
      };
      registry.nixpkgs.to = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        rev = args.inputs.nixpkgs.rev;
      };
      nixPath = [ "nixpkgs=flake:nixpkgs" ];
      gc = {
        automatic = true;
        options = "-d";
      };
      optimise.automatic = true;
    };

    nixpkgs = {
      system = args.system;
      config = args.config;
      flake = {
        setFlakeRegistry = false;
        setNixPath = false;
      };
      overlays = with args.inputs; [
        (
          final: prev:
          {
            nix = prev.nixVersions.latest;
            gtk2 = prev.writeShellScriptBin "gtk-query-immodules-2.0" "";
            coreutils-full = final.coreutils;
          }
        )
        self.overlays.default
      ];
    };

    environment = {
      defaultPackages = [ ];
      systemPackages = packages;
    };

    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = false;
    }
    // lib.optionalAttrs (args.distro == "nixos") {
      nixos.enable = false;
    };
  }
  // lib.optionalAttrs (!args.root) {
    home-manager.sharedModules = [
      {
        xdg.mime.enable = false;
        programs.man.package = null;
        manual.manpages.enable = false;
      }
    ];
  };

  standloneCfg =
    removeAttrs systemCfg [
      "documentation"
      "environment"
      "home-manager"
    ]
    // {
      nix = removeAttrs systemCfg.nix [ "optimise" ];
      nixpkgs = removeAttrs systemCfg.nixpkgs [ "flake" ];
      home.packages = packages;
      i18n.glibcLocales = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        pkgs.glibcLocales.override { allLocales = false; }
      );
      xdg.mime.enable = false;
      systemd.user.systemctlPath = "/usr/bin/systemctl";
      programs.man.package = null;
      manual.manpages.enable = false;
    };
in
if (args.distro == "home") then standloneCfg else systemCfg
