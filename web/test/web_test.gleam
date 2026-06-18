import birdie
import content/fs
import content/md
import gleeunit
import mork

pub fn main() -> Nil {
  gleeunit.main()
}

const path = "my/file/path.md"

const content = "
---
title: My Page title
---

# This is a heading

This is some more content

```ts
This is a code snippet
```

<div>Normal Div</div>

<special-tag>This is my special tag</special-tag>

- First list item
- Second list item
- <third-special>List Item</third-special>
"

pub fn mork_parser_test() {
  let file = fs.File(path, path, content:)
  let assert Ok(parsed) = md.parse_markdown_file(file)

  parsed.doc
  |> mork.to_html
  |> birdie.snap("basic rendered html from markdown")
}
