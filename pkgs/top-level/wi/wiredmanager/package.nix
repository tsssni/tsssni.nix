{
  networkmanager,
  store-prune,
}:
store-prune networkmanager {
  paths = [ "lib/NetworkManager/${networkmanager.version}/libnm-{wwan,device-plugin-wwan}.so" ];
}
