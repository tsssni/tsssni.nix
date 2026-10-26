def main [settings_file: path, config_file: path] {
    let target = $config_file | path expand
    if ($target | str starts-with "/nix/store/") {
        error make {msg: "Codex config resolves into the Nix store"}
    }

    let existed = $target | path exists
    let original = if $existed { open --raw $target } else { "" }
    let current = if ($original | str trim | is-empty) { {} } else { $original | from toml }
    let settings = open --raw $settings_file | from json
    let merged = $current | merge deep --strategy overwrite $settings | to toml
    let directory = $target | path dirname

    mkdir $directory
    let candidate = mktemp --tmpdir-path $directory ".codex-config.XXXXXX"
    try {
        $merged | save --raw --force $candidate
        if ($config_file | path expand) != $target {
            error make {msg: "Codex config path changed during activation"}
        }
        if $existed {
            if not ($target | path exists) or (open --raw $target) != $original {
                error make {msg: "Codex config changed during activation"}
            }
        } else if ($target | path exists) {
            error make {msg: "Codex config appeared during activation"}
        }
        mv --force $candidate $target
    } catch {|err|
        rm --force $candidate
        error make {msg: $err.msg}
    }
}
