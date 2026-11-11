{
  lib,
  stdenv,
  fastfetch,
  fastfetch-unwrapped,
  libglvnd,
  vulkan-loader,
  yyjson,
  apple-sdk_15,
}:
fastfetch.override {
  fastfetch-unwrapped = fastfetch-unwrapped.overrideAttrs (prev: {
    buildInputs = [
      yyjson
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libglvnd
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];
    cmakeFlags =
      lib.subtractLists [
        (lib.cmakeBool "ENABLE_EMBEDDED_PCIIDS" true)
        (lib.cmakeBool "ENABLE_EMBEDDED_AMDGPUIDS" true)
      ] prev.cmakeFlags
      ++ map (flag: lib.cmakeBool flag false) [
        "ENABLE_IMAGE_LOGO"
        "ENABLE_WAYLAND"
        "ENABLE_XCB_RANDR"
        "ENABLE_XRANDR"
        "ENABLE_GLX"
        "ENABLE_DRM"
        "ENABLE_VADRM"
        "ENABLE_VAX11"
        "ENABLE_VDPAU"
        "ENABLE_GIO"
        "ENABLE_DCONF"
        "ENABLE_EET"
        "ENABLE_DBUS"
        "ENABLE_SQLITE3"
        "ENABLE_RPM"
        "ENABLE_OPENCL"
        "ENABLE_ELF"
        "ENABLE_ZLIB"
        "ENABLE_LUA"
        "ENABLE_LIBZFS"
        "ENABLE_EMBEDDED_PCIIDS"
        "ENABLE_EMBEDDED_AMDGPUIDS"
        "BUILD_FLASHFETCH"
      ]
      ++ [ (lib.cmakeBool "ENABLE_VULKAN" stdenv.hostPlatform.isLinux) ];
    preConfigure = ''
      for module in src/modules/*; do
        [ -d "$module" ] || continue
        module="$(basename "$module")"
        if [[ " cpu gpu kernel opengl os shell vulkan " != *" $module "* ]]; then
          flag="$(printf '%s' "$module" | tr '[:lower:]' '[:upper:]')"
          cmakeFlagsArray+=("-DMODULE_DISABLE_$flag=ON")
        fi
      done
    '';
    postFixup = (prev.postFixup or "") + ''
      rm -r $out/share/bash-completion $out/share/zsh $out/share/fish
    '';
  });
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libglvnd
    vulkan-loader
  ];
}
