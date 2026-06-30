import consts
import gleam/list
import gleam/result
import js/dom
import lustre/element
import rendering/assets.{type Page, Page}
import rendering/components/custom_el
import rendering/components/snippet

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "htmlsnippet")

  let updates =
    tree.nodes
    |> list.try_map(fn(node) {
      use file <- result.map(snippet.load(node, page.path, "path"))

      render(file.relative, file.content)
      |> element.to_string
      |> dom.NodeUpdate(node.node, _)
    })

  use update_nodes <- result.try(updates)

  let html = dom.update_nodes(tree.root, update_nodes)

  Ok(Page(..page, html:))
}

fn render(title: String, code: String) {
  let snip = snippet.render(title, code)

  custom_el.site_snippet_preview([], [
    snip,
    element.unsafe_raw_html(consts.html_namespace, "div", [], code),
  ])
}
