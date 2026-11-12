tsssni.nix
============

## Intro

- Modules & Packages shared via flakes
- Framework for building reproducible system and desktop configurations
- Nixvim with friendly shortcuts and powerful plugins

## Usage

### flake

Put tsssni.nix in your flake inputs. Only support unstable.

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  tsssni = {
    url = "github:tsssni/tsssni.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

### modules

Provide modules in `tsssni.${platform}Modules.tsssni`. Include in corresponiding options and extend `lib` with `tsssni.lib`.

```nix
let
  pkgs = import inputs.nixpkgs {
    inherit system;
  };
  lib = inputs.nixpkgs.lib.extend (final: prev: tsssni.lib);
in
{
  nixosConfigurations.tsssni = nixpkgs.lib.nixosSystem {
    inherit lib;
    modules = [ tsssni.nixosModules.tsssni ];
  };
  darwinConfigurations.tsssni = nix-darwin.lib.darwinSystem {
    inherit lib;
    modules = [ tsssni.darwinModules.tsssni ];
  };
  homeConfigurations.tsssni = home-manager.lib.homeManagerConfiguration {
    inherit lib pkgs;
    modules = [ tsssni.homeModules.tsssni ];
  };
}
```

### pkgs

Provide pkgs via overlays.

```nix
nixpkgs.overlays = [ inputs.tsssni.overlays.default ];
```

## Config

- System configs: `configs/{nixos,darwin}/<host>/system/`
- System home configs: `configs/{nixos,darwin}/<host>/<user>/`
- Standalone home configs: `configs/home/<user>/`

Each host or standalone user directory needs a `rebuild.nix`:

```nix
inputs: {
  root = true;
  system = "x86_64-linux";
  config = {
    cudaSupport = true;
    cudaCapabilities = [ "8.9" ]
  };
  modules = with inputs; {
    system = [ self.nixosModules.tsssni ];
  };
}
```
