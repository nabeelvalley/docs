import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/result
import js/dom
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}
import rendering/components/snippet

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "csssnippet")

  let updates =
    tree.nodes
    |> list.map(fn(node) {
      use css <- result.try(snippet.load(node, "path"))
      use html <- result.map(snippet.load(node, "htmlpath"))
      let show_html = dict.from_list(node.attrs) |> dict.has_key("html")

      render(css, html, show_html)
      |> element.to_string
      |> dom.NodeUpdate(node.node, _)
    })
    |> result.all

  use update_nodes <- result.try(updates)

  let html = dom.update_nodes(tree.root, update_nodes)

  Ok(Page(..page, html:))
}

fn render(css: fs.File, html: fs.File, show_html: Bool) {
  let html_snip = snippet.render(css.relative, css.content)
  let css_snip = snippet.render(html.relative, html.content)

  let snips = case show_html {
    True -> html.div([], [css_snip, html_snip])
    False -> css_snip
  }

  // uses https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@scope
  // to scope the CSS to the parent element that also contains the rendered HTML
  let scoped_css = "@scope {" <> css.content <> "}"
  let preview =
    html.div([], [
      html.style([], scoped_css),
      element.unsafe_raw_html(consts.html_namespace, "div", [], html.content),
    ])

  element.element("site-snippet-preview", [], [snips, preview])
}
