{
  lib,
  pipewire,
  ffmpeg-headless,
}:
pipewire.overrideAttrs (prev: {
  buildInputs = lib.remove ffmpeg-headless prev.buildInputs;
  mesonFlags =
    lib.subtractLists [
      (lib.mesonEnable "ffmpeg" true)
      (lib.mesonEnable "pw-cat-ffmpeg" true)
    ] prev.mesonFlags
    ++ [
      (lib.mesonEnable "ffmpeg" false)
      (lib.mesonEnable "pw-cat-ffmpeg" false)
    ];
  postInstall = (prev.postInstall or "") + ''
    cd $out/lib
    rm -rf \
      gstreamer-1.0 \
      spa-0.2/{libcamera,avb,jack,audiotestsrc,videotestsrc} \
      pipewire-0.3/jack \
      pipewire-0.3/libpipewire-module-{roc-*,ffado-driver,avb,raop-*,snapcast-discover,zeroconf-discover,jack*,netjack2-*,vban-*,rtp-*,x11-bell}.so
    cd -
  '';
})
