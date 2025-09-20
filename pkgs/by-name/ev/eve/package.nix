{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "eve";
  version = "2025.09.20";

  src = fetchFromGitHub {
    owner = "jfalcou";
    repo = "eve";
    rev = "29f5596";
    sha256 = "sha256-HL9ZITRs8sohDeVC1mYJjPImGclXXSWm1Pw5huf6AHs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Expressive Vector Engine - SIMD in C++ Goes Brrrr";
    homepage = "https://jfalcou.github.io/eve/";
    license = lib.licenses.boost;
    platforms = lib.platforms.linux;
  };
}
