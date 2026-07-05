{
  buildFHSEnv,
  dbus,
  fetchurl,
  fontconfig,
  glib,
  lib,
  libdrm,
  libglvnd,
  libpng,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  makeWrapper,
  perl,
  stdenv,
  vulkan-loader,
  wayland,
  extraPkgs ? pkgs: [ ],
}:
let
  version = "2026.2.0";
  vercode = "26134";
  hash = "sha256-gXwkSUpxpzidd2E7ZZ7/m3KpdHqendcDUQ9J260QoIk=";

  pver = builtins.replaceStrings [ "." ] [ "_" ] version;
  subdir = "NVIDIA-Nsight-Graphics-${lib.versions.majorMinor version}";
  hostDir = "opt/${subdir}/host/linux-desktop-nomad-x64";

  fhsEnv = buildFHSEnv {
    pname = "nsight-graphics-fhs-env";
    inherit version;
    runScript = "";
    targetPkgs =
      pkgs:
      [
        dbus
        fontconfig
        glib
        libdrm
        libglvnd
        libpng
        libx11
        libxcb
        libxcb-cursor
        libxcb-image
        libxcb-keysyms
        libxcb-render-util
        libxcb-util
        libxcb-wm
        libxfixes
        libxi
        libxkbcommon
        libxrandr
        libxrender
        vulkan-loader
        wayland
      ]
      ++ extraPkgs pkgs;
  };
in
stdenv.mkDerivation {
  pname = "nsight-graphics";
  version = "${version}.${vercode}";

  src = fetchurl {
    url = "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-graphics/${pver}/linux_x64/NVIDIA_Nsight_Graphics_${version}.${vercode}-linux_x64.run";
    inherit hash;
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    sh $src --target extracted --noexec --keep
    ( cd extracted && perl ./install-linux.pl -noprompt -targetpath="$out/opt" )

    makeWrapper ${fhsEnv}/bin/nsight-graphics-fhs-env $out/bin/ngfx-ui \
      --add-flags $out/${hostDir}/ngfx-ui \
      --argv0 ngfx-ui
    makeWrapper ${fhsEnv}/bin/nsight-graphics-fhs-env $out/bin/ngfx \
      --add-flags $out/${hostDir}/ngfx \
      --argv0 ngfx

    runHook postInstall
  '';

  meta = {
    description = "Standalone application for the debugging and profiling of graphics applications";
    homepage = "https://developer.nvidia.com/nsight-graphics";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ngfx-ui";
  };
}
