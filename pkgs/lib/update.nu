export def update-file [file: string, attrs: record] {
  let content = (open --raw $file)
  let changes = (
    $attrs
    | transpose attr value
    | each {|row|
      let pat = $row.attr + ' = "(?<v>[^"]+)";'
      let old = ($content | parse --regex $pat | get v.0?)
      if $old != $row.value {
        { attr: $row.attr, old: $old, new: $row.value, pat: $pat }
      } else {
        null
      }
    }
    | compact
  )

  if ($changes | is-empty) { return }
  print $file
  $changes
  | reduce --fold $content {|c, acc|
    print $"  ($c.attr): ($c.old) → ($c.new)"
    let rep = $c.attr + ' = "' + $c.new + '";'
    $acc | str replace --regex $c.pat $rep
  }
  | save -f $file
}
