export def latest-tag [repo: string]: nothing -> string {
  ^gh release view --repo $repo --json tagName -q .tagName | str trim
}

export def latest-release [repo: string]: nothing -> record {
  let tag = (latest-tag $repo)
  let hash = (^nurl -H $"https://github.com/($repo)" $tag | str trim)
  { tag: $tag, hash: $hash }
}

export def branches [repo: string]: nothing -> list<string> {
  ^gh api $"repos/($repo)/branches?per_page=100" --paginate -q '.[].name' | lines
}

export def releases [repo: string]: nothing -> list<string> {
  ^gh api $"repos/($repo)/releases?per_page=100" --paginate -q '.[].tag_name' | lines
}
