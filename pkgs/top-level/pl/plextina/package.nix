{
  lib,
  symlinkJoin,
  runCommand,
  ibm-plex,
  nerd-fonts,
  python3,
}:
let
  cjk = [
    "sans-jp"
    "sans-tc"
    "sans-sc"
  ];
  files = {
    mono = "IBMPlexMono";
    sans = "IBMPlexSans";
    serif = "IBMPlexSerif";
    math = "IBMPlexMath";
    sans-sc = "IBMPlexSansSC";
    sans-tc = "IBMPlexSansTC";
    sans-jp = "IBMPlexSansJP";
  };
  plex = ibm-plex.override { families = lib.attrNames files; };
  bases = {
    sans-tc = [ "sans-jp" ];
    sans-sc = [
      "sans-jp"
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
      braille = runCommand "plextina-braille" env ''
        mkdir -p $out/share/fonts/truetype
        pyftsubset ${nerd-fonts.blex-mono}/share/fonts/truetype/NerdFonts/BlexMono/BlexMonoNerdFontMono-Regular.ttf \
          --unicodes=U+2800-28FF \
          --output-file=$out/share/fonts/truetype/Braille-Regular.ttf
      '';
    };

  env = {
    nativeBuildInputs = [ (python3.withPackages (p: [ p.fonttools ])) ];
    meta = { inherit (plex.meta) platforms; };
  };

  merged =
    n: family: styles: extra:
    runCommand "plextina-${n}" env ''
      mkdir -p $out/share/fonts/truetype
      for style in ${toString styles}; do
        python3 ${./merge.py} --layout "${family}" \
          ${fonts.${n}}/share/fonts/opentype/${files.${n}}-''${style%:*}.otf \
          ${toString extra} \
          ${
            cjk |> map (c: "${fonts.${c}}/share/fonts/opentype/${files.${c}}-\${style#*:}.otf") |> toString
          } \
          $out/share/fonts/truetype/${lib.replaceStrings [ " " ] [ "" ] family}-''${style%:*}.ttf
      done
    '';

  renamed =
    n: family: styles:
    runCommand "plextina-${n}" env ''
      mkdir -p $out/share/fonts/opentype
      for style in ${toString styles}; do
        python3 ${./merge.py} "${family}" \
          ${fonts.${n}}/share/fonts/opentype/${files.${n}}-$style.otf \
          $out/share/fonts/opentype/${lib.replaceStrings [ " " ] [ "" ] family}-$style.otf
      done
    '';
in
symlinkJoin {
  pname = "plextina";
  inherit (plex) version meta;
  paths = [
    (merged "mono" "Plextina Mono"
      [
        "Regular:Regular"
        "Bold:Bold"
        "Italic:Regular"
        "BoldItalic:Bold"
      ]
      [
        "${fonts.symbols}/share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFont-Regular.ttf"
        "${fonts.braille}/share/fonts/truetype/Braille-Regular.ttf"
      ]
    )
    (renamed "sans" "Plextina Sans" [
      "Regular"
      "Bold"
      "Italic"
      "BoldItalic"
    ])
    (renamed "serif" "Plextina Serif" [
      "Regular"
      "Bold"
      "Italic"
      "BoldItalic"
    ])
    (renamed "math" "Plextina Math" [ "Regular" ])
  ];
  passthru = fonts;
}
