{
  gst_all_1,
  gst-prune,
}:
gst-prune gst_all_1.gst-plugins-bad {
  post = "find lib -mindepth 1 -maxdepth 1 -name 'lib*' ! -name 'libgstcodecparsers-1.0.so*' -delete";
}
