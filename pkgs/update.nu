#!/usr/bin/env nu

let here = $env.FILE_PWD
let scripts = (glob $"($here)/by-name/**/update.nu" | sort)

let results = ($scripts | par-each {|s|
  let name = ($s | path dirname | path basename)
  let out = (^nu -I $here $s | complete)
  { name: $name, stdout: $out.stdout, stderr: $out.stderr, exit: $out.exit_code }
})

for $r in $results {
  print $"(ansi yellow_bold)updating(ansi reset) (ansi cyan)($r.name)(ansi reset)"
  if $r.stdout != "" { print -n $r.stdout }
  if $r.exit != 0 and $r.stderr != "" { print $r.stderr }
}
