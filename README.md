# tsssni.nix

![md0](./asset/visual.png)

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

Provide modules in `tsssni.${platform}Modules.tsssni`. Include in corresponiding options.

```nix
nixosConfigurations.tsssni = nixpkgs.lib.nixosSystem {
  modules = [ tsssni.nixosModules.tsssni ];
};
darwinConfigurations.tsssni = nix-darwin.lib.darwinSystem {
  modules = [ tsssni.darwinModules.tsssni ];
};
{
  home-manager.users.tsssni = { ... }: {
    imports = [ tsssni.homeModules.tsssni ];
  };
}
```

### pkgs

Provide pkgs via overlays.

```nix
nixpkgs.overlays = inputs.tsssni.pkgs;
```

## Config

Put system configs under `./configs/(nixos|nix-darwin)/${host-name}` and home-manager configs under `./configs/home-manager/${user-name}`. Write system configs under `${config-path}/system/` and home-manager configs under `${config-path}/${user-name}/`, should have `rebuild.nix` under above directories. Build system with `(nixos|darwin)-rebuild switch --flake .` or build home with `home-manager switch --flake .`.

`rebuild.nix` should follow this format. `system` is required since it could not be detected.

```nix
{
  system = "x86_64-linux";
  config = {
    cudaSupport = true;
    cudaCapabilities = [ "8.9" ];
  };
}
```

