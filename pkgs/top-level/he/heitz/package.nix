{
  cmake,
  fetchurl,
  lib,
  ninja,
  stdenv,
  unzip,
  spp ? 256,
}:
let
  validSpps = [
    1
    2
    4
    8
    16
    32
    64
    128
    256
  ];
  sppStr = toString spp;
in
assert lib.assertOneOf "spp" spp validSpps;
stdenv.mkDerivation (finalAttrs: {
  pname = "heitz";
  version = "hal-02150657-${sppStr}spp";

  src = fetchurl {
    url = "https://hal.science/hal-02150657/file/samplerCPP.zip";
    sha256 = "sha256-pWy9WfVElQjjToSabWLW0qIJK++Lnmk6UjKzXitMa3A=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  postPatch = ''
    mkdir -p samplerCPP/heitz
    cp ${./heitz.h} samplerCPP/heitz/heitz.h
    cp ${./CMakeLists.txt} samplerCPP/CMakeLists.txt
    cp ${./heitz-config.cmake.in} samplerCPP/heitz-config.cmake.in
  '';

  cmakeDir = "../samplerCPP";

  cmakeFlags = [
    "-DSPP=${sppStr}"
  ];

  meta = {
    description = "Heitz et al. SIGGRAPH 2019 blue-noise sampler tables (${sppStr} spp variant)";
    homepage = "https://hal.science/hal-02150657";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
