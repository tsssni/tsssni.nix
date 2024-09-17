{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "tsssni-grub-theme";
  version = "dev";

  src = fetchFromGitHub ({
    owner = "tsssni";
    repo = "tsssni.grub";
    rev = "31272f17529ae693eba311ac556e91a2660242f1";
    hash = "sha256-N9uyk88QtIlG15kveiOF/Yh8E/frEwWbT3kB5PEvq3M=";
  });

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r ./* $out/

    runHook postInstall
  '';

  meta = {
    description = "tsssmi grub theme";
    homepage = "https://github.com/tsssni/tssni-grub-theme";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
