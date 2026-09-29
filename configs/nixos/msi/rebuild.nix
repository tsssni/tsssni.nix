inputs: {
  root = false;
  system = "x86_64-linux";
  config = {
    cudaSupport = true;
    allowUnfree = true;
  };
  modules = with inputs; {
    system = [
      self.nixosModules.tsssni
      agenix.nixosModules.age
      home-manager.nixosModules.home-manager
    ];
    home = [
      self.homeModules.tsssni
      nixvim.homeModules.nixvim
      json2steamshortcut.homeModules.default
    ];
  };
}
