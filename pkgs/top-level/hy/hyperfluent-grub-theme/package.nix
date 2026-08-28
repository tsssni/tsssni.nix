{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hyperfluent-grub-theme";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Coopydood";
    repo = "HyperFluent-GRUB-Theme";
    rev = "v${version}";
    hash = "sha256-zryQsvue+YKGV681Uy6GqnDMxGUAEfmSJEKCoIuu2z8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r ./nixos/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Boot your machine in style with a fluent, modern, and clean GRUB theme. Choose from a growing list of theme variants to show off your *NIX distro!";
    homepage = "https://github.com/Coopydood/HyperFluent-GRUB-Theme";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
