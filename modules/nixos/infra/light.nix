{
  pkgs,
  lib,
  config,
  extendModules,
  ...
}:
let
  cfg = config.tsssni.infra.light;
  opt = type: default: lib.mkOption { inherit type default; };

  junk = [
    "etc/bash_completion.d"
    "include"
    "lib/*.{a,la,prl}"
    "lib/{cmake,girepository-1.0,pkgconfig}"
    "nix-support"
    "share/{aclocal,bash-completion,cmake,doc,fish,gir-1.0,info,locale,man,pkgconfig,vala,zsh}"
  ];

  walk = root: body: ''
    shopt -s nullglob
    for f in ${junk |> map (j: "${root}/${j}") |> toString}; do
      if [ -e "$f" ] || [ -L "$f" ]; then
        case "$(realpath "$(dirname "$f")")" in
          ${root} | ${root}/*) ${body} ;;
        esac
      fi
    done
  '';

  key = p: p |> toString |> builtins.unsafeDiscardStringContext;
  old = n: n |> lib.splitString "." |> lib.flip lib.getAttrFromPath pkgs;
  rep = oldDependency: newDependency: { inherit oldDependency newDependency; };
  reps = a: b: b |> lib.filterAttrs (_: lib.isDerivation) |> lib.mapAttrsToList (n: rep a.${n}.out);
  strip = drv: pkgs.store-prune drv { post = walk "$out" ''rm -rf "$f"''; };
  clear = drv: rep drv (pkgs.store-prune drv { paths = [ "*" ]; });
  dynamic = drv: rep drv (strip drv);

  stored = p: {
    type = "derivation";
    name = builtins.substring 44 (builtins.stringLength p) p;
    outPath = builtins.appendContext p { ${p}.path = true; };
  };

  base =
    (extendModules { modules = [ { tsssni.infra.light.enable = lib.mkForce false; } ]; })
    .config.system.build.toplevel;
  closure = pkgs.closureInfo { rootPaths = [ base ]; };
  present = "${closure}/store-paths" |> builtins.readFile |> lib.splitString "\n";

  scan = pkgs.runCommandLocal "light-scan" { inherit closure; } ''
    while read p; do
      ${walk "$p" ''echo "\"$p\""; break''}
    done < $closure/store-paths > list
    { echo "["; cat list; echo "]"; } > $out
  '';

  swaps =
    cfg.scopes
    |> lib.mapAttrsToList (n: reps (old n))
    |> lib.concat [ (lib.mapAttrsToList (n: rep (old n)) cfg.replace) ]
    |> lib.concatLists;
  clears = map clear cfg.clear;

  expand =
    r:
    lib.optional (lib.elem (key r.newDependency) present) r.newDependency
    |> lib.concat [ r.oldDependency ]
    |> map (d: rep d (strip r.newDependency));
  explicit = clears ++ lib.concatMap expand swaps;
  excluded = map key ([ base ] ++ cfg.keep ++ lib.concatMap lib.attrValues (swaps ++ clears));
in
{
  options.tsssni.infra.light = with lib.types; {
    enable = lib.mkEnableOption "tsssni.infra.light";
    replace = opt (attrsOf package) { };
    scopes = opt (attrsOf raw) { };
    clear = opt (listOf package) [ ];
    keep = opt (listOf package) [ ];
  };

  config = lib.mkIf cfg.enable {
    system.replaceDependencies.replacements =
      import scan
      |> lib.subtractLists excluded
      |> map (p: dynamic (stored p))
      |> lib.concat explicit;
  };
}
