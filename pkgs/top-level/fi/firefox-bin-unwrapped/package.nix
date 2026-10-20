{
  firefox-bin-unwrapped,
}:
firefox-bin-unwrapped.overrideAttrs (prev: {
  postFixup = (prev.postFixup or "") + ''
    cd $out/lib/firefox-bin-${prev.version}
    rm libonnxruntime.so libmozinference.so crashhelper crashreporter pingsender updater updater.ini
    cd -
  '';
})
