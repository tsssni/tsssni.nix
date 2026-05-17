#!/usr/bin/env nu
use lib/github.nu *

let d = $env.FILE_PWD
let h = $"($d)/hashes.nix"

let fs = [
  serif sans sans-condensed sans-arabic sans-devanagari
  sans-thai sans-thai-looped sans-sc sans-tc sans-kr
  sans-jp sans-hebrew mono math
]

let tags = (releases "IBM/plex")
let old = (^nix eval --json --file $h | from json)

let es = ($fs | par-each {|f|
  let prefix = $"@ibm/plex-($f)@"
  let v = (
    $tags
    | where {|t| $t | str starts-with $prefix }
    | each {|t| $t | str replace $prefix '' }
    | sort-by {|x|
      let p = ($x | split row "." | each {|y| $y | into int })
      ($p.0 * 1000000) + (($p.1? | default 0) * 1000) + ($p.2? | default 0)
    }
    | last
  )
  let url = $"https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-($f)%40($v)/ibm-plex-($f).zip"
  let h = (^nurl -H -f fetchzip $url | str trim)
  let prev = ($old | get -o $f)
  { f: $f, v: $v, h: $h, old_v: (if $prev == null { null } else { $prev.version }), old_h: (if $prev == null { null } else { $prev.hash }) }
})

let sorted = ($fs | each {|f| $es | where f == $f | first })
let lines = ($sorted | each {|e| $'  "($e.f)" = { version = "($e.v)"; hash = "($e.h)"; };' + "\n" })
let new_hash = $"{\n($lines | str join)}\n"
let old_hash = (open --raw $h)

let new = ($es | where {|e| $e.old_v != $e.v or $e.old_h != $e.h })
if not ($new | is-empty) {
  print $h
  for $e in $new {
    let old_label = if $e.old_v == null { "absent" } else { $e.old_v }
    print $"  ($e.f): ($old_label) → ($e.v)"
  }
}

if $new_hash != $old_hash {
  $new_hash | save -f $h
}
