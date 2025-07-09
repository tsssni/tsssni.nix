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
    rev = "0238197";
    sha256 = "sha256-5cxT6qm+Bx9qoyDhOIZQB2Ih/aeOTB+N9WJfJMMd9oI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://microsoft.github.io/proxy/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
