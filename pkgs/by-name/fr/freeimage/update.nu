#!/usr/bin/env nu
use lib/update.nu *
use lib/github.nu *

let f = $"($env.FILE_PWD)/package.nix"
let r = (latest-release "danoli3/FreeImage")
let v = ($r.tag | str replace --regex '^v' '')
update-file $f { version: $v, hash: $r.hash }
