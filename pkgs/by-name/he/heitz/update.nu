#!/usr/bin/env nu
use lib/update.nu *

let f = $"($env.FILE_PWD)/package.nix"
let url = "https://hal.science/hal-02150657/file/samplerCPP.zip"
let hash = (^nurl -H -f fetchurl $url | str trim)

update-file $f { sha256: $hash }
