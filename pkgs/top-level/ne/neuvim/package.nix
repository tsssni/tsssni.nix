{
  lib,
  stdenv,
  neovim-unwrapped,
  tree-sitter,
}:
(neovim-unwrapped.override {
  tree-sitter = lib.makeOverridable (
    _:
    stdenv.mkDerivation {
      inherit (tree-sitter) pname version src;
      __structuredAttrs = true;
      strictDeps = true;
      makeFlags = [ "PREFIX=$(out)" ];
      passthru = { inherit (tree-sitter) buildGrammar; };
    }
  ) { };
}).overrideAttrs
  (prev: {
    postInstall = (prev.postInstall or "") + ''
      cd $out/share/nvim/runtime
      rm -r doc colors keymap pack spell tutor neovim.ico plugin/matchit.vim plugin/netrwPlugin.vim
      find syntax -mindepth 1 ! -name syntax.vim ! -name synload.vim ! -name nosyntax.vim ! -name manual.vim -delete
      cd -
    '';
  })
