import gleam/list
import gleam/pair
import gleam/result
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}
import rendering/components/snippet

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "script-raw")

  let updates =
    tree.nodes
    |> list.try_map(fn(node) {
      use file <- result.map(snippet.load(node, "path"))

      render(file.content, node.attrs)
      |> element.to_readable_string
      |> dom.NodeUpdate(node.node, _)
    })

  use update_nodes <- result.try(updates)

  let html = dom.update_nodes(tree.root, update_nodes)

  Ok(Page(..page, html:))
}

fn render(code: String, attrs) {
  let custom_attrs =
    attrs
    |> list.map(fn(a) { attribute.attribute(a |> pair.first, a |> pair.second) })

  html.script(custom_attrs, code)
}
