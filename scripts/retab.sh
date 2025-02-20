find . -name "*.nix" -type f -exec nvim --headless -c '%s/^\( \{2\}\)\+/\=substitute(submatch(0), "  ", "\t", "g")/ge | wq' {} \;
