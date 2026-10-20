{
  imagemagick,
  jovian-updater-logo-helper,
}:
jovian-updater-logo-helper.override {
  imagemagick = imagemagick.override {
    bzip2Support = false;
    djvulibreSupport = false;
    fftwSupport = false;
    fontconfigSupport = false;
    freetypeSupport = false;
    lcms2Support = false;
    libX11Support = false;
    libXtSupport = false;
    libheifSupport = false;
    libjpegSupport = false;
    libjxlSupport = false;
    liblqr1Support = false;
    librawSupport = false;
    libraqmSupport = false;
    librsvgSupport = false;
    libtiffSupport = false;
    libultrahdrSupport = false;
    libwebpSupport = false;
    libxml2Support = false;
    openexrSupport = false;
    openjpegSupport = false;
  };
}
