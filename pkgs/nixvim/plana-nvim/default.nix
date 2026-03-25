build: plugins:
build {
  name = "plana.nvim";
  src = ./.;
  dependencies = [ plugins.lush-nvim ];
}
