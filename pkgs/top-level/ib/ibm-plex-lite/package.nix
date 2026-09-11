{
  lib,
  symlinkJoin,
  ibm-plex,
  families ? [ ],
  webfont ? false,
}:
let
  plex = ibm-plex.override { inherit families; };
  strip = font: {
    preInstall = font.preInstall + ''
      find . -type d -name ttf -exec rm -rf {} +
    '';
  };
  fonts =
    plex.passthru
    |> lib.filterAttrs (n: v: lib.isDerivation v && !lib.hasSuffix "-variable" n)
    |> lib.mapAttrs (n: v: v.overrideAttrs strip);
in
symlinkJoin {
  pname = "ibm-plex-lite";
  inherit (plex) version meta;
  paths = lib.attrValues fonts ++ lib.optionals webfont (lib.mapAttrsToList (_: f: f.webfont) fonts);
  passthru = fonts;
}
