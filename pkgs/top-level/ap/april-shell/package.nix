{
  lib,
  makeWrapper,
  quickshell,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  name = "april-shell";
  src = ./.;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${quickshell}/bin/quickshell $out/bin/${name} \
      --add-flags "-p ${src}"
  '';

  meta = {
    mainProgram = "april-shell";
    platforms = lib.platforms.linux;
  };
}
