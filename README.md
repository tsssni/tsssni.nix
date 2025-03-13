# tsssni.nix

![md0](./configs/nixos/msi/tsssni/visual/md0.png)

![md1](./configs/nixos/msi/tsssni/visual/md1.png)

## Intro

- Modules & Functions & Packages shared via flake outputs
- Framework for building system configs used on tssssni's NixOS PC & Nix-Darwin Macbook Air
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

Provide modules in `tsssni.${platform}Modules.tsssni`. You include them in corresponiding options.
```nix
nixosConfigurations.tsssni = nixpkgs.lib.nixosSystem {
  modules = [ tsssni.nixosModules.tsssni ];
};
darwinConfigurations.tsssni = nix-darwin.lib.darwinSystem {
  modules = [ tsssni.darwinModules.tsssni ];
};
{
  home-manager.users.tsssni = { ... }: {
    imports = [ tsssni.homeManagerModules.tsssni ];
  };
}
```

### lib
Provide lib with `tsssni.lib`. You could include it in module special args.
```nix
specialArgs = { tsssni.lib = tsssni.lib; };
```

### pkgs
Provide pkgs with `tsssni.pkg`. You could call it with desired args and include it in module special args.
```nix
specialArgs = { tsssni.pkgs = tsssni.pkgs {
  localSystem = "aarch64-darwin";
  crossSystem = "aarch64-embedded";
  config.allowUnfree = true;
};
```

## Config

Put system configs under `./configs/(nixos|nix-darwin)/${host-name}` and home-manager configs under `./configs/home-manager/${user-name}`. Write system configs under `${config-path}/system/` and home-manager configs under `${config-path}/${user-name}/`, should have `rebuild.nix` under above directories. Build system with `(nixos|darwin)-rebuild switch --flake .` or build home with `home-manager switch --flake .`.

`rebuild.nix` should follow this format. `system` is required since it could not be detected, and `extra*` configs could be added.

```nix
{
  inputs
, tsssni
, func
}:
import ../rebuild.nix {
	inherit inputs tsssni func;
	system = "x86_64-linux";
	extraSystemModules = with inputs; [
		agenix.nixosModules.age
	];
	extraHomeManagerModules = with inputs; [
		nixvim.homeManagerModules.nixvim
		ags.homeManagerModules.ags
	];
}
```

