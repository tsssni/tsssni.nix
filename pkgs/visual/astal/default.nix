{
  stdenvNoCC
, lib
, makeWrapper
, astal
, ags
, hyprland
, playerctl
, imagemagick
, curl
, python3
, rocmPackages
}:
let
  name = "tsssni-astal";
in stdenvNoCC.mkDerivation {
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
	  hyprland
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
	  --prefix GI_TYPELIB_PATH ':' ${lib.makeSearchPath "lib/girepository-1.0" [
		  astal.hyprland
	  ]} \
	  --prefix PATH ':' ${lib.makeBinPath [
		  ags
		  hyprland
		  playerctl
		  imagemagick
		  curl
		  rocmPackages.rocm-smi
		  (python3.withPackages (python-pkgs: [
			  python-pkgs.psutil
		  ]))
	  ]}
  '';
}
