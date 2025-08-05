{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "proxy";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "proxy";
    rev = "82bb5d5";
    sha256 = "sha256-TbnDWK+eHon515oCLuL+5rh7bw3JbP8Nze4qfABQEJs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://microsoft.github.io/proxy/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
