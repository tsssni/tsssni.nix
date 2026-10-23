{
  lib,
  stdenv,
  fastfetch,
  libglvnd,
  vulkan-loader,
}:
fastfetch.override {
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libglvnd
    vulkan-loader
  ];
}
