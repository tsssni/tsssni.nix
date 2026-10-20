#!/usr/bin/env nu

def main [] {}

def output [key: string, value] {
  $"($key)=($value)\n" | save --append $env.GITHUB_OUTPUT
}

def "main update" [] {
  nix flake update
  nu ./pkgs/update.nu

  git add -A
  if (git diff --cached --quiet | complete).exit_code == 0 {
    print "nothing changed, nothing to do"
    output proceed false
    return
  }

  print "update found, proceeding"
  git config user.name "Claude"
  git config user.email "noreply@anthropic.com"
  if (git log -1 --format=%s | str trim) == "flake: update" {
    git commit --amend --no-edit
    git push --force-with-lease origin HEAD:master
  } else {
    git commit -m "flake: update"
    git push origin HEAD:master
  }

  output proceed true
  output rev (git rev-parse HEAD | str trim)
}

const runners = {
  x86_64-linux: { os: "ubuntu-26.04", platform: "linux" }
  i686-linux: { os: "ubuntu-26.04", platform: "linux" }
  aarch64-linux: { os: "ubuntu-26.04-arm", platform: "linux" }
  aarch64-darwin: { os: "macos-26", platform: "darwin" }
}

const stages = 8

def entry [system: string, name: string, attr: string] {
  $runners | get $system | merge { name: $name, attr: $attr }
}

def "main matrix" [] {
  let jobs = (
    nix eval --json .#hydraJobs --apply '
      h: builtins.concatMap (k: builtins.concatMap (g: map (n: {
        name = "${k}.${g}.${n}";
        system = h.${k}.${g}.${n}.system;
        drv = h.${k}.${g}.${n}.drvPath;
      }) (builtins.attrNames h.${k}.${g})) (builtins.attrNames h.${k})) (builtins.attrNames h)
    '
    | from json
    | uniq-by drv
  )
  let pending = (
    nix build --dry-run --no-link ...($jobs | each { |j| $"($j.drv)^*" })
    | complete
    | get stderr
    | lines
    | str trim
    | where $it ends-with ".drv"
  )
  let jobs = $jobs | where drv in $pending
  let drvs = $jobs | get drv
  let deps = $jobs | each { |j|
    { drv: $j.drv, deps: (nix-store --query --requisites $j.drv | lines | where { |d| $d != $j.drv and $d in $drvs }) }
  }

  mut levels = []
  mut stage = 0
  while ($levels | length) < ($deps | length) {
    $stage += 1
    let current = $stage
    let done = $levels | each { |l| $l.drv }
    let ready = $deps | where { |r| $r.drv not-in $done and ($r.deps | all { |d| $d in $done }) }
    if ($ready | is-empty) {
      error make { msg: "dependency cycle in hydraJobs" }
    }
    $levels = $levels | append ($ready | each { |r| { drv: $r.drv, stage: $current } })
  }
  if $stage > $stages {
    error make { msg: $"hydraJobs need ($stage) stages, workflow has ($stages)" }
  }

  let levels = $levels
  let matrix = (
    1..$stages
    | each { |s|
      let include = (
        $jobs
        | where { |j| ($levels | where drv == $j.drv | first | get stage) == $s }
        | each { |j| entry $j.system $j.name $"hydraJobs.($j.name)" }
      )
      { key: $"stage($s)", include: $include }
    }
    | where { |s| $s.include | is-not-empty }
    | reduce --fold {} { |s, acc| $acc | insert $s.key { include: $s.include } }
  )

  let configs = (
    [
      [kind attr system];
      ["nixosConfigurations" "config.system.build.toplevel" "x86_64-linux"]
      ["homeConfigurations" "activationPackage" "x86_64-linux"]
      ["darwinConfigurations" "system" "aarch64-darwin"]
    ]
    | each { |t|
      nix eval --json $".#($t.kind)" --apply builtins.attrNames
      | from json
      | each { |n| entry $t.system $"($t.kind).($n)" $"($t.kind).($n).($t.attr)" }
    }
    | flatten
  )
  output matrix ($matrix | insert configs { include: $configs } | to json --raw)
}
