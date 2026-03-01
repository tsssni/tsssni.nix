{
  fetchzip,
  stdenv,
  lib,
  apple-sdk_26,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "metal-cpp";
  version = "26";

  src = fetchzip {
    url = "https://developer.apple.com/metal/cpp/files/metal-cpp_${version}.zip";
    hash = "sha256-7n2eI2lw/S+Us6l7YPAATKwcIbRRpaQ8VmES7S8ZjY8=";
    stripRoot = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ apple-sdk_26 ];

  postUnpack = ''
    cp ${./CMakeLists.txt} $sourceRoot/CMakeLists.txt
    cp ${./metal-cpp-config.cmake.in} $sourceRoot/metal-cpp-config.cmake.in
  '';

  meta = {
    description = "Metal-cpp is a low-overhead C++ interface for Metal that helps you add Metal functionality to graphics apps, games, and game engines that are written in C++.";
    homepage = "https://developer.apple.com/metal/cpp/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
  };
}
