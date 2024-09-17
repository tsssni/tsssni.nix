{
  lib
, stdenv
, fetchFromGitHub
, CoreFoundation
, readline
, gcc
, lua
}:
stdenv.mkDerivation {
  pname = "sketchybar-lua";
  version = "dev";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "29395b1";
    sha256 = "sha256-C2tg1mypz/CdUmRJ4vloPckYfZrwHxc4v8hsEow4RZs=";
  };

  nativeBuildInputs = [ gcc ];
  buildInputs = [ CoreFoundation readline lua ];
  enableParallelBuilding = true;

  buildPhase = ''
    make bin/sketchybar.so
  '';

  installPhase = ''
    mkdir -p $out/share
    cp bin/sketchybar.so $out/share/sketchybar.so
  '';

  meta = with lib; {
    description = "A Lua API for SketchyBar";
    homepage = "https://github.com/FelixKratz/SbarLua";
    license = licenses.gpl3;
    platforms = platforms.darwin;
  };
}
