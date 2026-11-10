inputs: {
  root = false;
  system = "x86_64-linux";
  config.allowUnfree = true;
  modules = with inputs; {
    home = [
      self.homeModules.tsssni
      nixvim.homeModules.nixvim
    ];
  };
}
