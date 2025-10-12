{
  description = "tsssni flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      lib = inputs.nixpkgs.lib;
      configArgs = {
        inherit inputs;
        tsssni = {
          inherit (self)
            pkgs
            lib
            nixosModules
            darwinModules
            homeModules
            ;
          extraNixosModules = with inputs; [
            agenix.nixosModules.age
            disko.nixosModules.disko
            nixos-wsl.nixosModules.wsl
            jovian.nixosModules.jovian
          ];
          extraDarwinModules = with inputs; [
            agenix.darwinModules.age
          ];
          extraHomeModules = with inputs; [
            nixvim.homeModules.nixvim
            niri.homeModules.niri
          ];
        };
      };
      collectConfigs =
        distro:
        ./configs/${distro}
        |> builtins.readDir
        |> lib.filterAttrs (dir: type: type == "directory")
        |> lib.mapAttrs (
          dir: _: (import ./configs/${distro}/${dir}/rebuild.nix (configArgs // { func = dir; }))
        );
    in
    {
      pkgs = import ./pkgs lib;
      nixosModules = {
        tsssni = import ./modules/nixos;
        default = self.nixosModules.tsssni;
      };
      darwinModules = {
        tsssni = import ./modules/nix-darwin;
        default = self.darwinModules.tsssni;
      };
      homeModules = {
        tsssni = import ./modules/home-manager;
        default = self.homeModules.tsssni;
      };
      nixosConfigurations = collectConfigs "nixos";
      darwinConfigurations = collectConfigs "nix-darwin";
      homeConfigurations = collectConfigs "home-manager";
    };
}
