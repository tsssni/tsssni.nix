{ lib
, stdenvNoCC
, fetchFromGitHub
, p7zip
}:
stdenvNoCC.mkDerivation rec {
  pname = "darwin-nerd-fonts";
  version = "latest";

  sf-mono-nerd-liga = fetchFromGitHub {
    owner = "shaunsingh";
    repo = "SFMono-Nerd-Font-Ligaturized";
    rev = "dc5a3e6";
    sha256 = "sha256-AYjKrVLISsJWXN6Cj74wXmbJtREkFDYOCRw1t2nVH2w=";
  };


  nativeBuildInputs = [ p7zip ];
  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype/darwin-nerd-fonts
    cp ${sf-mono-nerd-liga}/*.otf $out/share/fonts/opentype/darwin-nerd-fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Darwin nerd fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}

