#!/usr/bin/env nu

def main [
  host: string
] {
  if not ("flake.nix" | path exists) {
    error make { msg: "run scripts/cross.nu from the repo root" }
  }

  let link = (mktemp --tmpdir --directory | path join "result")

  nh os build . --hostname $host --out-link $link
  let toplevel = ($link | path expand)
  print $"built ($toplevel)"

  nix run nixpkgs#cachix -- push tsssni $toplevel
}
