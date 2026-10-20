{
  mpv,
  mpv-unwrapped,
  ffmpeg-decode,
}:
let
  unwrapped =
    (mpv-unwrapped.override {
      ffmpeg = ffmpeg-decode;
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
        buildInputs = map (p: if p == prev.passthru.luaEnv then prev.passthru.lua else p) prev.buildInputs;
        passthru = prev.passthru // {
          luaEnv = prev.passthru.lua;
        };
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
