{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "freeimage";
  version = "3.19.11";

  src = fetchFromGitHub {
    owner = "danoli3";
    repo = "FreeImage";
    rev = finalAttrs.version;
    hash = "sha256-XkrplbD3ar6Dox5X172HYLEbOLgPMg2tV60E9nILKQI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "FREEIMAGE_BUILD_TESTS" false)
  ];

  meta = {
    description = "Open source library for popular graphics image formats (danoli3 CMake fork)";
    homepage = "https://github.com/danoli3/FreeImage";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    knownVulnerabilities = [
      "FreeImage has a long history of CVEs; upstream is unmaintained. Use only when no alternative is viable."
    ];
  };
})
