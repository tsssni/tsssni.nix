#!/usr/bin/env nu

def main [
  target: string
  ip: string
  identity: string
  age_dir: string
] {
  if not ("flake.nix" | path exists) {
    error make { msg: "run scripts/deploy.nu from the repo root" }
  }

  let identity_path = ($identity | path expand)
  let keys_dir = $"/tmp/($target)-keys"
  let key_path = $"($keys_dir)/etc/ssh/ssh_host_ed25519_key"
  let age_dir = ($age_dir | path expand)
  let secrets_file = $"($age_dir)/secrets.nix"
  let remote = $"root@($ip)"

  let bootstrap = "
    set -euo pipefail
    if [ ! -f /swap ]; then
      fallocate -l 2G /swap
      chmod 600 /swap
      mkswap /swap
      swapon /swap
    fi
    swapon --show
    free -h
    sed -i -e 's/^#*\\s*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    grep -q '^PubkeyAuthentication' /etc/ssh/sshd_config || echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
    systemctl reload sshd 2>/dev/null || service ssh reload
  "
  ssh -i $identity_path $remote $bootstrap
  ssh-copy-id -i $"($identity_path).pub" $remote

  if not ($key_path | path exists) {
    mkdir $"($keys_dir)/etc/ssh"
    ssh-keygen -t ed25519 -N "" -C $"root@($target)" -f $key_path
    chmod 600 $key_path
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
    cd $age_dir
    nix run github:ryantm/agenix -- -r -i $identity_path
  }

  print "building zram-enabled kexec installer ..."
  let kexec_dir = (
    nix build --refresh --print-out-paths
      github:luqasn/nixos-images#packages.x86_64-linux.kexec-installer-nixos-unstable-noninteractive
    | str trim
  )
  let kexec_tarball = $"($kexec_dir)/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz"
  print $"kexec tarball: ($kexec_tarball)"

  print $"deploying ($target) to ($remote)"
  (nix run github:nix-community/nixos-anywhere --
    -i $identity_path
    --build-on local
    --no-substitute-on-destination
    --kexec $kexec_tarball
    --extra-files $keys_dir
    --flake $".#($target)"
    --target-host $remote)
  ssh-keygen -R $ip
  print $"done, host key kept at ($keys_dir)"
}
