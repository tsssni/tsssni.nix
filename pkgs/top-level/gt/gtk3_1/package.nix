{
  gtk3,
}:
(gtk3.override { trackerSupport = false; }).overrideAttrs (prev: {
  postInstall = prev.postInstall + ''
    rm -r $out/share/gtk-3.0/emoji
  '';
})
