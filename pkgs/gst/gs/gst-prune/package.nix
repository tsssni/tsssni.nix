{
  store-prune,
}:
drv:
{
  post ? "",
}:
store-prune drv {
  paths = [
    "bin"
    "lib/gstreamer-1.0"
  ];
  inherit post;
}
