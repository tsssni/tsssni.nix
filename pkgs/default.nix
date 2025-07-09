lib: [
  (final: prev: {
    vimPlugins = prev.vimPlugins // (final.callPackage ./nixvim { });
  })
  (import ./by-name-overlay.nix lib ./by-name)
]
