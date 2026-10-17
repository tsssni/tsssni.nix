#!/usr/bin/env nu
use lib/update.nu *

let f = $"($env.FILE_PWD)/package.nix"

let loc = (
  ^curl -sI "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher-x86_64.AppImage"
  | lines
  | where ($it | str lowercase | str starts-with "location:")
  | first
)
let m = ($loc | parse --regex 'EGLv2/(?<ver>[^/%]+)%2B(?<build>[^/]+)/Linux/' | first)
if ($m | is-empty) { error make { msg: "no linux appimage found" } }

let base = $"https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/($m.ver)%2B($m.build)"
let linuxHash = (nurl -H -f fetchurl $"($base)/Linux/EpicGamesLauncher-x86_64.AppImage" | str trim)
let darwinHash = (nurl -H -f fetchurl $"($base)/macOS/EpicGamesLauncher.dmg" | str trim)

update-file $f { version: $m.ver, build: $m.build, linuxHash: $linuxHash, darwinHash: $darwinHash }
