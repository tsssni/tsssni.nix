#!/usr/bin/env nu
use lib/update.nu *

let f = $"($env.FILE_PWD)/package.nix"

let headers = curl --fail --silent --show-error --head --retry 3 "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.deb"
let release = (
  $headers | lines | str trim
  | parse --regex '(?i)^location:\s*.*EGLv2/(?<ver>[^/%]+)(?:%2B|\+)(?<build>[^/]+)/Linux/'
  | first
)
let base = $"https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/($release.ver)%2B($release.build)"
let linuxHash = nurl -H -f fetchurl $"($base)/Linux/EpicGamesLauncher-x86_64.deb"
let darwinHash = nurl -H -f fetchurl $"($base)/macOS/EpicGamesLauncher.dmg"

update-file $f {
  version: $release.ver
  build: $release.build
  linuxHash: ($linuxHash | str trim)
  darwinHash: ($darwinHash | str trim)
}
