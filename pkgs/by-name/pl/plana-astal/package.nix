{
  stdenvNoCC,
  lib,
  makeWrapper,
  astal,
  ags,
  playerctl,
  imagemagick,
}:
let
  name = "plana-astal";
in
stdenvNoCC.mkDerivation {
  inherit name;
  src = ./src;

  nativeBuildInputs = [
    ags
    makeWrapper
  ];

  buildInputs = with astal; [
    io
    gjs
    astal3
  ];

  installPhase = ''
    mkdir -p $out/bin
    ags bundle app.ts $out/bin/${name}.js -d "SRC='${./src}'"
    cat > $out/bin/${name} << EOF
    #!/bin/sh
    exec ags run $out/bin/${name}.js "\$@"
    EOF
    chmod +x $out/bin/${name}
  '';

  preFixup = ''
    wrapProgram $out/bin/${name} \
    --prefix PATH ':' ${
      lib.makeBinPath [
        ags
        playerctl
        imagemagick
      ]
    }
  '';
}
