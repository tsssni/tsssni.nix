{
  nerd-fonts,
}:
nerd-fonts.blex-mono.overrideAttrs (prev: {
  pname = "blextina";
  postInstall = (prev.postInstall or "") + ''
    find $out/share/fonts -name '*NerdFontMono-*' -delete
    find $out/share/fonts -name '*NerdFontPropo-*' -delete
  '';
})
