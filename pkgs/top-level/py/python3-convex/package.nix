{
  python3,
  store-prune,
}:
store-prune python3 {
  paths = [ "lib/${python3.libPrefix}/{config-*/*.a,idlelib,tkinter,test,ensurepip}" ];
  post = "find . -name __pycache__ -prune -exec rm -rf {} +";
}
