import birdie
import content/frontmatter
import content/fs
import date
import gleam/javascript/promise
import gleam/list
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import js/dom
import js/marked
import js/sharp
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/ssr/css_snippet
import simplifile

pub fn main() -> Nil {
  gleeunit.main()
}

const md_frontmatter = "---
title: Some title
date: 2026-01-31
tags:
  - blog
  - test
---
"

const md_content = "
# This is a heading

This is some more content

```ts
This is a code snippet
  That has some indentation
```

<div>Normal Div</div>

<special-tag>This is my special tag</special-tag>

- First list item
- Second list item
- <third-special>List Item</third-special>
"

pub fn markdown_parser_test() {
  let parsed = marked.parse(md_content)

  parsed
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

  let tree = dom.get_nodes(html:, tag: "my-tag")
  let updates =
    tree.nodes
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

  dom.update_nodes(tree.root, updates)
  |> birdie.snap("update html from tag visitor")
}

pub fn update_dom_self_closing_test() {
  let html =
    "
    <my-tag id=\"flag1\" data=\"self-closing1\" />
    <my-tag id=\"flag2\" data=\"self-closing2\" />
    <my-tag id=\"flag3\" data=\"self-closing3\" />
  "

  let tree = dom.get_nodes(html:, tag: "my-tag")

  let updates =
    tree.nodes
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

  dom.update_nodes(tree.root, updates)
  |> birdie.snap("respects custom self closing tags")
}

pub fn sharp_test() {
  let out_path = "./out/test/images/home/code.jpg"
  use _ <- promise.await(sharp.optimize_image(
    in_path: "./public/images/home/code.jpg",
    out_path:,
  ))

  let assert Ok(is_file) = simplifile.is_file(out_path)

  should.be_true(is_file) |> promise.resolve
}

pub fn css_snippet_render_test() {
  let result =
    css_snippet.render(
      fs.File("path.css", "path.css", "h1 { color: red; }"),
      fs.File("path.html", "path.html", "<h1>Hello there</h1>"),
      True,
    )

  result |> element.to_readable_string |> birdie.snap("css snippet rendering")
}

pub fn extract_frontmatter_test() {
  let content = md_frontmatter <> md_content

  let assert Ok(result) =
    frontmatter.extract(fs.File(
      path: "my/path.md",
      relative: "my/path.md",
      content:,
    ))

  result.frontmatter
  |> should.equal(
    frontmatter.Frontmatter(
      title: "Some title",
      date: Some(date.IsoDate(year: 2026, month: 1, day: 31)),
      description: None,
      published: False,
      feature: False,
      rss_only: False,
      layout: frontmatter.ArticleLayout,
      tags: ["blog", "test"],
    ),
  )

  result.content |> birdie.snap("markdown content")
}
