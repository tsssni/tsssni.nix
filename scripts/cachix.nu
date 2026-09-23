#!/usr/bin/env nu

def main [] {}

def output [key: string, value] {
  $"($key)=($value)\n" | save --append $env.GITHUB_OUTPUT
}

def "main update" [] {
  nix flake update
  nix shell nixpkgs#nurl --command nu ./pkgs/update.nu

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

def "main matrix" [] {
  let targets = [
    [kind attr os platform];
    ["nixosConfigurations" "config.system.build.toplevel" "ubuntu-26.04" "linux"]
    ["homeConfigurations" "activationPackage" "ubuntu-26.04" "linux"]
    ["darwinConfigurations" "system" "macos-26" "darwin"]
    ["packages.x86_64-linux" "" "ubuntu-26.04" "linux"]
    ["packages.aarch64-linux" "" "ubuntu-26.04-arm" "linux"]
    ["packages.aarch64-darwin" "" "macos-26" "darwin"]
  ]
  let include = (
    $targets
    | each { |t|
      nix eval --json $".#($t.kind)" --apply builtins.attrNames
      | from json
      | each { |name| $t | insert name $name }
    }
    | flatten
  )
  output matrix ({ include: $include } | to json --raw)
}
