{
  lib,
  symlinkJoin,
  ibm-plex,
  nerd-fonts,
  python3,
  families ? [ ],
  webfont ? false,
}:
let
  plex = ibm-plex.override { inherit families; };
  cjk = [
    "sans-sc"
    "sans-tc"
    "sans-jp"
    "sans-kr"
  ];
  bases = {
    sans-tc = [ "sans-sc" ];
    sans-jp = [
      "sans-sc"
      "sans-tc"
    ];
  };
  strip = n: font: {
    preInstall =
      font.preInstall
      + ''
        find . -type d -name ttf -exec rm -rf {} +
      ''
      + lib.optionalString (lib.elem n cjk) ''
        find . \( -name '*-Thin.*' -o -name '*-ExtraLight.*' -o -name '*-Text.*' \) -delete
      '';
  };
  subset =
    n: font:
    lib.optionalAttrs (bases ? ${n}) {
      nativeBuildInputs = (font.nativeBuildInputs or [ ]) ++ [
        (python3.withPackages (p: [ p.fonttools ]))
      ];
      postInstall = (font.postInstall or "") + ''
        for f in $out/share/fonts/opentype/*.otf; do
          python3 ${./subset.py} ${
            toString (map (b: "${fonts.${b}}/share/fonts/opentype/*-Regular.otf") bases.${n})
          } $f
        done
      '';
    };
  fonts =
    plex.passthru
    |> lib.filterAttrs (n: v: lib.isDerivation v && !lib.hasSuffix "-variable" n)
    |> lib.mapAttrs (n: v: v.overrideAttrs (font: strip n font // subset n font))
    |> lib.mergeAttrs {
      symbols = nerd-fonts.symbols-only.overrideAttrs (font: {
        postInstall = (font.postInstall or "") + ''
          find $out/share/fonts -name '*Mono*' -delete
        '';
      });
    };
in
symlinkJoin {
  pname = "plextina";
  inherit (plex) version meta;
  paths = lib.attrValues fonts ++ lib.optionals webfont (lib.mapAttrsToList (_: f: f.webfont) fonts);
  passthru = fonts;
}
