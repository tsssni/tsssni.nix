{
  hwdata,
  store-prune,
}:
store-prune hwdata { paths = [ "share/hwdata/{iab,oui}.txt" ]; }
