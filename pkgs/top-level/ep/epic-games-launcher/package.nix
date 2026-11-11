{
  autoPatchelfHook,
  buildFHSEnv,
  cairo,
  dbus,
  dpkg,
  fetchurl,
  gdk-pixbuf,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gst_all_1,
  gtk3,
  lib,
  libayatana-appindicator,
  libGL,
  libsoup_3,
  libx11,
  libxi,
  stdenv,
  stdenvNoCC,
  undmg,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:
let
  pname = "epic-games-launcher";
  version = "0.114.0";
  build = "g04485d6";
  linuxHash = "sha256-C9Pj7CdsGvXIZwMlxXtwKSkPtIEd4Hhb/jYqMWE/lsc=";
  darwinHash = "sha256-H4Nj8a0sy7s8E9hkvDKQyQe7Ulttfq6Z4S+Bm/DNNKY=";

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
        url = "${baseUrl}/Linux/EpicGamesLauncher-x86_64.deb";
        hash = linuxHash;
      };
      unwrapped = stdenvNoCC.mkDerivation {
        pname = "${pname}-unwrapped";
        inherit version src;
        nativeBuildInputs = [
          autoPatchelfHook
          dpkg
          wrapGAppsHook3
        ];
        buildInputs = [
          cairo
          dbus
          gdk-pixbuf
          glib
          glib-networking
          gsettings-desktop-schemas
          gtk3
          libsoup_3
          libx11
          stdenv.cc.cc.lib
          webkitgtk_4_1
        ]
        ++ (with gst_all_1; [
          gst-plugins-base
          gst-plugins-good
          gst-plugins-bad
          gst-libav
        ]);
        runtimeDependencies = [
          (lib.getLib libayatana-appindicator)
          (lib.getLib libGL)
          (lib.getLib libxi)
        ];
        unpackPhase = ''
          runHook preUnpack
          dpkg-deb -x "$src" .
          runHook postUnpack
        '';
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r usr/. $out/
          runHook postInstall
        '';
      };
    in
    buildFHSEnv {
      inherit
        pname
        version
        meta
        ;
      includeClosures = true;
      targetPkgs =
        pkgs: with pkgs; [
          unwrapped
          python3
          SDL2
          gamemode
          libgcrypt
          libxcomposite
          libxxf86vm
          mangohud
          vulkan-loader
        ];
      runScript = "${unwrapped}/bin/EpicGamesLauncher";
      profile = ''
        export EGL_DISABLE_SELF_UPDATE=1
      '';
      extraInstallCommands = ''
        install -Dm644 ${unwrapped}/share/applications/epic-games-launcher.desktop $out/share/applications/epic-games-launcher.desktop
        substituteInPlace $out/share/applications/epic-games-launcher.desktop --replace-fail 'Exec=EpicGamesLauncher' 'Exec=${pname}'
        cp -r ${unwrapped}/share/icons $out/share/icons
      '';
      passthru = { inherit src unwrapped; };
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
