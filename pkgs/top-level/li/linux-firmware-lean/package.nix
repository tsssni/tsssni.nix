{
  linux-firmware,
  store-prune,
}:
keep:
store-prune linux-firmware {
  post = ''
    find . -mindepth 1 -maxdepth 1 ! -name lib -exec rm -rf {} +
    cd lib/firmware
    for f in $(find ${toString keep} -type l); do
      cp --remove-destination "$(readlink -f "$f")" "$f"
    done
    find . ! -type d ${keep |> map (k: "! -path './${k}'") |> toString} -delete
    find . -type d -empty -delete
  '';
}
