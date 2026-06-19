import birdie
import content/fs
import content/md
import gleam/list
import gleam/string
import gleeunit
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import mork

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn mork_parser_test() {
  let path = "my/file/path.md"

  let content =
    "
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
    |> string.trim

  let file = fs.File(path, path, content:)
  let assert Ok(parsed) = md.parse_markdown_file(file)

  parsed.doc
  |> mork.to_html
  |> dom.pretty
  |> birdie.snap(title: "basic rendered html from markdown")
}

pub fn update_dom_test() {
  let html =
    "
  <body>
    <h1>Heading</h1>

    <p>
      Some content
      <my-tag id=\"flag1\" data=\"some-data\">Find me</my-tag>
    </p>

    <my-tag id=\"flag2\" data=\"child-data\"><h2>Child content</h2></my-tag>
  </body>"

  let result =
    dom.update(html:, tag: "my-tag", visit: fn(children, attrs) {
      let content =
        list.map(attrs, fn(a) {
          let #(key, value) = a

          html.meta([attribute.name(key), attribute.value(value)])
        })

      html.div([attribute.class("parsed flag")], [
        html.meta([attribute.name("children"), attribute.value(children)]),
        ..content
      ])
      |> element.to_readable_string
    })

  result
  |> birdie.snap("update html from tag visitor")
}
