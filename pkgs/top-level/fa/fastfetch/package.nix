{
  lib,
  stdenv,
  fastfetch,
  fastfetch-unwrapped,
  libglvnd,
  vulkan-loader,
}:
fastfetch.override {
  fastfetch-unwrapped = fastfetch-unwrapped.overrideAttrs (prev: {
    postFixup = (prev.postFixup or "") + ''
      rm -r $out/share/bash-completion $out/share/zsh $out/share/fish
    '';
  });
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libglvnd
    vulkan-loader
  ];
}
