#!/usr/bin/env nu
use lib/update.nu *
use lib/github.nu *

let f = $"($env.FILE_PWD)/package.nix"
let r = (latest-release "ngcpp/proxy")
update-file $f { version: $r.tag, sha256: $r.hash }
