import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "snippet")

  let updates =
    tree.nodes
    |> list.try_map(fn(node) {
      use file <- result.map(load(node, page.path, "path"))

      render(file.path |> snippet_relative, file.content)
      |> element.to_string
      |> dom.NodeUpdate(node.node, _)
    })

  use update_nodes <- result.try(updates)

  let html = dom.update_nodes(tree.root, update_nodes)

  Ok(Page(..page, html:))
}

pub fn snippet_relative(path) {
  string.drop_start(path, string.length(consts.snippets_dir) - 1)
}

pub fn load(node: dom.Node, from_file: String, path_attr: String) {
  let attrs = dict.from_list(node.attrs)
  use path <- result.try(
    dict.get(attrs, path_attr)
    |> result.replace_error("could not read " <> path_attr <> " for snippet"),
  )

  let full_path = case path {
    "." <> _ -> {
      use parent <- result.try(fs.parent(from_file))
      fs.join([parent, path])
    }
    _ -> fs.join([consts.snippets_dir, path])
  }

  result.try(full_path, fs.read_file)
}

pub fn render(title: String, code: String) {
  let lang = fs.ext(title)

  html.figure([attribute.class("snippet")], [
    html.figcaption([], [html.text(title)]),

    html.pre([], [
      html.code([attribute.class("language-" <> lang)], [
        html.text(code),
      ]),
    ]),
  ])
}
