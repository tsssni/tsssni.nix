def main [settings_file: path, config_file: path] {
    let target = $config_file | path expand
    if ($target | str starts-with "/nix/store/") {
        error make {msg: $"Config ($target) resolves into the Nix store"}
    }

    let parsed = $config_file | path parse
    let ext = $parsed.extension | str lowercase
    if $ext not-in ["json" "toml"] {
        error make {msg: $"Unsupported config format: ($ext)"}
    }

    let existed = $target | path exists
    let original = if $existed { open --raw $target } else { "" }
    let current = if ($original | str trim | is-empty) {
        {}
    } else {
        match $ext {
            "json" => ($original | from json)
            "toml" => ($original | from toml)
        }
    }
    let settings = open --raw $settings_file | from json
    let merged = $current | merge deep --strategy overwrite $settings
    let rendered = match $ext {
        "json" => $"($merged | to json --indent 2)\n"
        "toml" => ($merged | to toml)
    }
    let directory = $target | path dirname

    mkdir $directory
    let candidate = mktemp --tmpdir-path $directory $".($parsed.stem).XXXXXX"
    try {
        $rendered | save --raw --force $candidate
        if ($config_file | path expand) != $target {
            error make {msg: $"Config path ($config_file) changed during activation"}
        }
        if $existed {
            if not ($target | path exists) or (open --raw $target) != $original {
                error make {msg: $"Config ($target) changed during activation"}
            }
        } else if ($target | path exists) {
            error make {msg: $"Config ($target) appeared during activation"}
        }
        mv --force $candidate $target
    } catch {|err|
        rm --force $candidate
        error make {msg: $err.msg}
    }
}
