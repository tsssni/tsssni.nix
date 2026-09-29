inputs: {
  root = false;
  system = "x86_64-linux";
  config.allowUnfree = true;
  modules = with inputs; {
    home = [
      self.homeModules.tsssni
      nixvim.homeModules.nixvim
      json2steamshortcut.homeModules.default
    ];
  };
}
