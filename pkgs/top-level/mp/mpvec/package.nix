{
  mpv,
  mpv-unwrapped,
}:
let
  unwrapped =
    (mpv-unwrapped.override {
      alsaSupport = false;
      archiveSupport = false;
      bluraySupport = false;
      cacaSupport = false;
      dvbinSupport = false;
      dvdnavSupport = false;
      javascriptSupport = false;
      openalSupport = false;
      rubberbandSupport = false;
      vdpauSupport = false;
      x11Support = false;
      zimgSupport = false;
    }).overrideAttrs
      (prev: {
        postFixup = (prev.postFixup or "") + ''
          printf '#!/bin/sh\n[ -n "$MPV" ] || MPV=mpv\nexec "$MPV" "$@"\n' > $out/bin/umpv
          rm $out/share/mpv/subfont.ttf
        '';
      });
in
(mpv.override {
  youtubeSupport = false;
  mpv-unwrapped = unwrapped;
}).overrideAttrs
  { paths = [ unwrapped.out ]; }
