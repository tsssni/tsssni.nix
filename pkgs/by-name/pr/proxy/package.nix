{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "proxy";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "proxy";
    rev = "${version}";
    sha256 = "sha256-Henut9u1JJNPJjxVJKLlEzKj636hVulkgfj0+zPwkAM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Proxy: Next Generation Polymorphism in C++";
    homepage = "https://microsoft.github.io/proxy/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
