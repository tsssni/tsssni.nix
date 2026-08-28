lib:
let
  byName = import ./by-name.nix lib;
  filter =
    overlay: select: pkgs:
    pkgs |> select |> lib.getAttrs (overlay { } { } |> builtins.attrNames);
in
{
  topLevel = rec {
    set = byName ./top-level;
    collect = filter set (pkgs: pkgs);
    merge = set;
  };
  cudaPackages = rec {
    set = byName ./cuda;
    collect = filter set (pkgs: pkgs.cudaPackages);
    merge = _: prev: { cudaPackages = prev.cudaPackages.overrideScope set; };
  };
  vimPlugins = rec {
    set = byName ./nixvim;
    collect = filter set (pkgs: pkgs.vimPlugins);
    merge = final: prev: { vimPlugins = prev.vimPlugins // set final prev; };
  };
}
