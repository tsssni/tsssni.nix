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
  gstPackages = rec {
    set = byName ./gst;
    collect = filter set (pkgs: pkgs.gstPackages);
    merge = final: _: { gstPackages = lib.makeScope final.newScope (self: set self { }); };
  };
  jovianPackages = rec {
    set = byName ./jovian;
    collect =
      pkgs: lib.optionalAttrs (pkgs ? jovianPackages) (filter set (pkgs: pkgs.jovianPackages) pkgs);
    merge =
      _: prev:
      lib.optionalAttrs (prev ? jovianPackages) {
        jovianPackages = prev.jovianPackages.overrideScope set;
      };
  };
  qt6Basic = rec {
    set = byName ./qt6;
    collect = filter set (pkgs: pkgs.qt6Basic);
    merge = final: _: { qt6Basic = lib.makeScope final.newScope (self: set self { }); };
  };
  vimPlugins = rec {
    set = byName ./nixvim;
    collect = filter set (pkgs: pkgs.vimPlugins);
    merge = final: prev: { vimPlugins = prev.vimPlugins // set final prev; };
  };
}
