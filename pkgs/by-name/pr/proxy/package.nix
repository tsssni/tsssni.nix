{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "proxy";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "ngcpp";
    repo = "proxy";
    rev = "${version}";
    sha256 = "sha256-nU1aQXW6HXvy9B2WdED8SH+/vYyxt2MWoUkS40UC8TA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://ngcpp.github.io/proxy/spec/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
