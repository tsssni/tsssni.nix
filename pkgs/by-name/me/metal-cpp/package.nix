{
  fetchzip,
  stdenv,
  lib,
  apple-sdk_26,
  cmake,
  version ? null,
}:
let
  hashes = import ./hashes.nix;
  modernVersions = lib.filter (v: builtins.match "[0-9]+(\\.[0-9]+)?" v != null) (
    builtins.attrNames hashes
  );
  latest = lib.head (lib.sort (a: b: builtins.compareVersions a b > 0) modernVersions);
  selected = if version == null then latest else version;
  hash = hashes.${selected} or (throw "metal-cpp: unknown version \"${selected}\"");
in
stdenv.mkDerivation {
  pname = "metal-cpp";
  version = selected;

  src = fetchzip {
    url = "https://developer.apple.com/metal/cpp/files/metal-cpp_${selected}.zip";
    inherit hash;
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
