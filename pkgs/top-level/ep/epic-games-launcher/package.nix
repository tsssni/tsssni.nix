{
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
  undmg,
}:
let
  pname = "epic-games-launcher";
  version = "0.106.0";
  build = "g0cb1183";
  linuxHash = "sha256-QVwiWRVC6+ZOLoji5wXO5XabobLI1TTezuYu75jRwkg=";
  darwinHash = "sha256-o6fCgEipwAV6igRwJkmbDDOBQwjpft8iPQ/wYBkplV4=";

  baseUrl = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/${version}%2B${build}";

  meta = {
    description = "Epic Games Launcher (EGLv2 preview)";
    homepage = "https://launcher.epicgames.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    mainProgram = pname;
  };

  linux =
    let
      src = fetchurl {
        url = "${baseUrl}/Linux/EpicGamesLauncher-x86_64.AppImage";
        hash = linuxHash;
      };
      contents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit
        pname
        version
        src
        meta
        ;

      extraInstallCommands = ''
        install -Dm644 ${contents}/usr/share/applications/epic-games-launcher.desktop $out/share/applications/epic-games-launcher.desktop
        substituteInPlace $out/share/applications/epic-games-launcher.desktop --replace-fail 'Exec=EpicGamesLauncher' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share/icons
      '';
    };

  darwin = stdenvNoCC.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "${baseUrl}/macOS/EpicGamesLauncher.dmg";
      hash = darwinHash;
    };

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -r "Epic Games Launcher.app" $out/Applications/
      ln -s "$out/Applications/Epic Games Launcher.app/Contents/MacOS/EpicGamesLauncher" $out/bin/${pname}

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux
