#!/usr/bin/env nu
use lib/update.nu *

let f = $"($env.FILE_PWD)/package.nix"

let page = (^curl -sL "https://developer.nvidia.com/nsight-graphics/get-started")
let m = (
  $page
  | parse --regex 'nsight-graphics/(?<dir>\d+_\d+_\d+)/linux_x64/NVIDIA_Nsight_Graphics_(?<ver>\d+\.\d+\.\d+)\.(?<code>\d+)-linux_x64\.run'
  | first
)

let url = $"https://developer.nvidia.com/downloads/assets/tools/secure/nsight-graphics/($m.dir)/linux_x64/NVIDIA_Nsight_Graphics_($m.ver).($m.code)-linux_x64.run"
let hash = (^nurl -H -f fetchurl $url | str trim)

update-file $f { version: $m.ver, vercode: $m.code, hash: $hash }
