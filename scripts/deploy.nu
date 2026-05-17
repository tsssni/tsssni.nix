#!/usr/bin/env nu

# Deploy a nixosConfiguration to a target VPS via nixos-anywhere.
# Flow: generate host key locally -> add to agenix publicKeys -> re-encrypt secrets -> deploy
# Swap: fallocate -l 2G /swap; chmod 600 /swap; mkswap /swap; swapon /swap; free -h; swapon --show

def main [
  target: string      # nixosConfigurations name (e.g. gkms)
  ip: string          # target VPS IP (ignored when --vm-test)
  identity: string    # ssh private key used by agenix for decryption
  --vm-test           # build + boot a local QEMU VM instead of deploying
] {
  if not ("flake.nix" | path exists) {
    error make { msg: "run scripts/deploy.nu from the repo root" }
  }

  let identity_path = ($identity | path expand)
  let keys_dir      = $"/tmp/($target)-keys"
  let key_path      = $"($keys_dir)/etc/ssh/ssh_host_ed25519_key"
  let secrets_file  = "modules/nixos/proxy/config/secrets.nix"

  if not ($key_path | path exists) {
    mkdir $"($keys_dir)/etc/ssh"
    ^ssh-keygen -t ed25519 -N "" -C $"root@($target)" -f $key_path
    ^chmod 600 $key_path
    print $"generated host key: ($key_path)"
  } else {
    print $"reusing host key: ($key_path)"
  }

  let pubkey = (open $"($key_path).pub" | str trim)
  let secrets = (open $secrets_file)
  if not ($secrets | str contains $pubkey) {
    $secrets
    | str replace 'publicKeys = [' $"publicKeys = [\n    \"($pubkey)\""
    | save -f $secrets_file
    print $"added pubkey to ($secrets_file)"
  }
  print $"re-encrypting age files, identity = ($identity_path) ..."
  do {
    cd ($secrets_file | path dirname)
    ^agenix -r -i $identity_path
  }

  if $vm_test {
    print $"running vm-test for ($target)"
    (^nix run github:nix-community/nixos-anywhere --
      --vm-test
      --flake $".#($target)")
  } else {
    print "building zram-enabled kexec installer ..."
    let kexec_dir = (
      ^nix build --refresh --print-out-paths
        github:luqasn/nixos-images#packages.x86_64-linux.kexec-installer-nixos-unstable-noninteractive
      | str trim
    )
    let kexec_tarball = $"($kexec_dir)/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz"
    print $"kexec tarball: ($kexec_tarball)"

    print $"deploying ($target) to root@($ip)"
    (^nix run github:nix-community/nixos-anywhere --
      -i $identity_path
      --build-on local
      --no-substitute-on-destination
      --kexec $kexec_tarball
      --extra-files $keys_dir
      --flake $".#($target)"
      --target-host $"root@($ip)")
    ^ssh-keygen -R $ip
    print $"done, host key kept at ($keys_dir)"
  }
}
