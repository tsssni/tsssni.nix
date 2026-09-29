inputs: {
  root = true;
  system = "x86_64-linux";
  config = { };
  modules = with inputs; {
    system = [
      self.nixosModules.tsssni
      disko.nixosModules.disko
      agenix.nixosModules.age
    ];
  };
}
