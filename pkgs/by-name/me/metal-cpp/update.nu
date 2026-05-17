#!/usr/bin/env nu
use lib/github.nu *

let d = $env.FILE_PWD
let h = $"($d)/hashes.nix"

let names = (branches "bkaradzic/metal-cpp")
let modern = ($names | parse --regex '^metal-cpp_(?<v>\d+(?:\.\d+)?)$' | get v)
let legacy = ($names | parse --regex '^metal-cpp_(?<v>macOS.+)$' | get v)

let old = (^nix eval --json --file $h | from json)

let es = (
  ($modern ++ $legacy)
  | par-each {|v|
    let url = $"https://developer.apple.com/metal/cpp/files/metal-cpp_($v).zip"
    let code = (^curl -sI -o /dev/null -w '%{http_code}' $url | str trim)
    if $code == "200" {
      let hash = (^nurl -H -f fetchzip $url | str trim)
      { v: $v, h: $hash, old_h: ($old | get -o $v) }
    } else {
      null
    }
  }
  | compact
)

let modern_sorted = ($es | where {|e| not ($e.v | str starts-with "macOS") } | sort-by {|e|
  let p = ($e.v | split row "." | each {|x| $x | into int })
  ($p.0 * 10000) + ($p.1? | default 0)
} | reverse)
let legacy_sorted = ($es | where {|e| $e.v | str starts-with "macOS" } | sort-by {|e|
  let mv = ($e.v | parse --regex '^macOS(?<v>\d+(?:\.\d+)?)' | get v.0)
  let p = ($mv | split row "." | each {|x| $x | into int })
  ($p.0 * 10000) + ($p.1? | default 0)
} | reverse)
let sorted = ($modern_sorted ++ $legacy_sorted)

let lines = ($sorted | each {|e| $'  "($e.v)" = "($e.h)";' + "\n" })
let new_hash = $"{\n($lines | str join)}\n"
let old_hash = (open --raw $h)

let new = ($sorted | where {|e| $e.old_h != $e.h })
if not ($new | is-empty) {
  print $h
  for $e in $new {
    let label = if $e.old_h == null { "added" } else { "updated" }
    print $"  ($e.v): ($label)"
  }
}

if $new_hash != $old_hash {
  $new_hash | save -f $h
}
