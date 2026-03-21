{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "proxy";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "ngcpp";
    repo = "proxy";
    rev = "${version}";
    sha256 = "sha256-E3Ccc8zWU4KEyhaoLUE3Wnq3ED/3lb97mpNCobOkIvQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://ngcpp.github.io/proxy/spec/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
