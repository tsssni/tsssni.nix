{
  ncurses,
  store-prune,
}:
store-prune ncurses {
  post = ''
    keep=" ${
      toString [
        "alacritty"
        "alacritty-direct"
        "dumb"
        "linux"
        "vt100"
        "vt220"
        "xterm"
        "xterm-256color"
      ]
    } "
    cd share/terminfo
    for f in */*; do
      [[ "$keep" == *" ''${f#*/} "* && -L "$f" ]] && cp --remove-destination "$(readlink -f "$f")" "$f"
    done
    for f in */*; do
      [[ "$keep" == *" ''${f#*/} "* ]] || rm "$f"
    done
    find . -type d -empty -delete
  '';
}
