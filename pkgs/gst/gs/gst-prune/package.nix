{
  store-prune,
}:
drv:
store-prune drv {
  paths = [
    "bin"
    "lib/gstreamer-1.0"
  ];
}
