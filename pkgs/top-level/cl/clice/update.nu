#!/usr/bin/env nu
use lib/update.nu *
use lib/github.nu *

let d = $env.FILE_PWD
let f = $"($d)/package.nix"
let tag = (latest-tag "clice-io/clice")
let version = ($tag | str trim --left --char 'v')

let old = (open --raw $f | parse --regex 'version = "(?<v>[^"]+)";' | get v.0?)
if $old == $version { exit 0 }

let targets = {
  x86_64-linux: "x86_64-unknown-linux-gnu"
  aarch64-linux: "aarch64-unknown-linux-gnu"
  aarch64-darwin: "aarch64-apple-darwin"
}

let hashes = (
  $targets
  | transpose system target
  | par-each {|row|
    let url = $"https://github.com/clice-io/clice/releases/download/($tag)/clice-($version).($row.target).tar.gz"
    let hash = (nurl -H -f fetchurl $url | str trim)
    { k: $row.system, v: $hash }
  }
  | reduce --fold {} {|e, acc| $acc | insert $e.k $e.v }
)

update-file $f { version: $version }
update-file $"($d)/hashes.nix" $hashes
