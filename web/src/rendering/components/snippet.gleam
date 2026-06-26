import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/result
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}

pub fn render_all(page: Page) -> Result(Page, String) {
  let #(root, nodes) = dom.get_nodes(page.html, tag: "snippet")

  let updates =
    nodes
    |> list.try_map(fn(node) {
      let attrs = dict.from_list(node.attrs)
      use path <- result.try(
        dict.get(attrs, "path")
        |> result.replace_error("could not read path for snippet"),
      )

      let full_path = fs.join([consts.snippets_dir, path])
      let read_file = fs.read_file(full_path, consts.snippets_dir)
      use file <- result.map(read_file)

      render(file.relative, file.content)
      |> element.to_readable_string
      |> dom.NodeUpdate(node.node, _)
    })

  use update_nodes <- result.try(updates)

  let html = dom.update_nodes(root, update_nodes)

  Ok(Page(..page, html:))
}

fn render(title: String, code: String) {
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
