{
  makeWrapper,
  kdePackages,
  quickshell,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  name = "april-shell";
  src = ./.;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = with kdePackages; ''
    mkdir -p $out/bin
    makeWrapper ${quickshell}/bin/quickshell $out/bin/${name} \
      --add-flags "-p ${src}" \
      --set QML2_IMPORT_PATH "${qtdeclarative}/lib/qt-6/qml:${qt5compat}/lib/qt-6/qml:${quickshell}/lib/qt-6/qml"
  '';

  meta.mainProgram = "april-shell";
}
