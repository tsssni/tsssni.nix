inputs: {
  root = false;
  system = "aarch64-darwin";
  config.allowUnfree = true;
  modules = with inputs; {
    system = [
      self.darwinModules.tsssni
      agenix.darwinModules.age
      home-manager.darwinModules.home-manager
    ];
    home = [
      self.homeModules.tsssni
      nixvim.homeModules.nixvim
      json2steamshortcut.homeModules.default
    ];
  };
}
