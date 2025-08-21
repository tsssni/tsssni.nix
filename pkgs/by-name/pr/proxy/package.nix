{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "proxy";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "proxy";
    rev = "${version}";
    sha256 = "sha256-WssVOwbRPozDboub8kRiOe7x3f6Fc4haVI1UNADBVpw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://microsoft.github.io/proxy/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
