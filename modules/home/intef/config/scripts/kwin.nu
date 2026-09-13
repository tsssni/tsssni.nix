def main [
  ...cmd: string
  --output (-o): string = "1"
  --sdr: int = 200
  --box: string = "/tmp/kwin-box"
  --keep
] {
  if ($cmd | is-empty) {
    error make { msg: "give a command to run inside the session" }
  }

  mkdir $"($box)/config"
  ln -sfn $"($env.HOME)/.config/fontconfig" $"($box)/config/fontconfig"

  let line = ($cmd | each { |a| $"'($a | str replace --all "'" "'\\''")'" } | str join " ")
  let hdr = $"kscreen-doctor output.($output).hdr.enable output.($output).wcg.enable output.($output).sdr-brightness.($sdr)"

  (
    nix shell nixpkgs#kdePackages.kwin nixpkgs#kdePackages.libkscreen nixpkgs#dbus nixpkgs#coreutils
    -c env $"HOME=($box)" $"XDG_CONFIG_HOME=($box)/config"
    dbus-run-session kwin_wayland --drm --no-lockscreen --exit-with-session $line -- $hdr
  ) out+err> $"($box)/kwin.log"

  if not $keep { rm -rf $box }
}
