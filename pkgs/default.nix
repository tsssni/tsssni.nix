[
  (final: prev: {
    plana-astal = final.callPackage ./by-name/pl/plana-astal/package.nix { };
    plana-grub = final.callPackage ./by-name/pl/plana-grub/package.nix { };
    proxy = final.callPackage ./by-name/pr/proxy/package.nix { };
    vimPlugins = prev.vimPlugins // (final.callPackage ./nixvim { });
  })
]
