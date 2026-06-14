{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "proxy";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "ngcpp";
    repo = "proxy";
    rev = "${version}";
    sha256 = "sha256-j+GSXQju4GdxGp/m/Fk1Qhxim8jjpb8cRVcB1mttA6E=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://ngcpp.github.io/proxy/spec/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
