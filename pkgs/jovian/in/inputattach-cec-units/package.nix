{
  inputattach-cec-units,
  linuxConsoleTools,
  store-prune,
}:
inputattach-cec-units.override {
  linuxConsoleTools = store-prune linuxConsoleTools {
    post = "find bin -mindepth 1 ! -name inputattach -delete";
  };
}
