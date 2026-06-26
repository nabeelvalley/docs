import birdie
import content/fs
import content/md
import gleam/javascript/promise
import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import js/dom
import js/sharp
import lustre/attribute
import lustre/element
import lustre/element/html
import simplifile

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn markdown_parser_test() {
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

  parsed.html
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

    <my-tag id=\"flag3\" data=\"self-closing\" />
  </body>"

  let #(root, nodes) = dom.get_nodes(html:, tag: "my-tag")
  let updates =
    nodes
    |> list.map(fn(node) {
      let content =
        list.map(node.attrs, fn(a) {
          let #(key, value) = a

          html.meta([attribute.name(key), attribute.value(value)])
        })

      html.div([attribute.class("parsed flag")], [
        html.meta([attribute.name("children"), attribute.value(node.content)]),
        ..content
      ])
      |> element.to_readable_string
      |> dom.NodeUpdate(node.node, _)
    })

  dom.update_nodes(root, updates)
  |> birdie.snap("update html from tag visitor")
}

pub fn update_dom_self_closing_test() {
  let html =
    "
    <my-tag id=\"flag1\" data=\"self-closing1\" />
    <my-tag id=\"flag2\" data=\"self-closing2\" />
    <my-tag id=\"flag3\" data=\"self-closing3\" />
  "

  let #(root, nodes) = dom.get_nodes(html:, tag: "my-tag")

  let updates =
    nodes
    |> list.map(fn(node) {
      let content =
        list.map(node.attrs, fn(a) {
          let #(key, value) = a

          html.meta([attribute.name(key), attribute.value(value)])
        })

      html.div([attribute.class("parsed flag")], [
        html.meta([attribute.name("children"), attribute.value(node.content)]),
        ..content
      ])
      |> element.to_readable_string
      |> dom.NodeUpdate(node.node, _)
    })

  dom.update_nodes(root, updates)
  |> birdie.snap("respects custom self closing tags")
}

pub fn sharp_test() {
  let out_path = "./out/test/images/home/code.jpg"
  use _ <- promise.await(sharp.optimize_image(
    in_path: "../public/images/home/code.jpg",
    out_path:,
  ))

  let assert Ok(is_file) = simplifile.is_file(out_path)

  should.be_true(is_file) |> promise.resolve
}
