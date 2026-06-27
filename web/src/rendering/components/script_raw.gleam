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
  let tree = dom.get_nodes(page.html, tag: "script-raw")

  let updates =
    tree.nodes
    |> list.try_map(fn(node) {
      let attrs = dict.from_list(node.attrs)
      use path <- result.try(
        dict.get(attrs, "path")
        |> result.replace_error("could not read path for snippet"),
      )

      let full_path = fs.join([consts.snippets_dir, path])
      let read_file = fs.read_file(full_path, consts.snippets_dir)
      use file <- result.map(read_file)

      render(file.content, attrs)
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
    |> dict.map_values(attribute.attribute)
    |> dict.values

  html.script(custom_attrs, code)
}
