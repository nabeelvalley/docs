import content/fs
import gleam/dict
import gleam/list
import gleam/result
import js/dom
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}
import rendering/ssr/custom_el
import rendering/ssr/snippet

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "csssnippet")

  let updates =
    tree.nodes
    |> list.map(fn(node) {
      use css <- result.try(snippet.load(node, page.path, "path"))
      use html <- result.map(snippet.load(node, page.path, "htmlpath"))
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

pub fn render(css: fs.File, html: fs.File, show_html: Bool) {
  let html_snip =
    snippet.render(css.path |> snippet.snippet_relative, css.content)
  let css_snip =
    snippet.render(html.path |> snippet.snippet_relative, html.content)

  let snips = case show_html {
    True -> html.div([], [css_snip, html_snip])
    False -> css_snip
  }

  // uses https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@scope
  // to scope the CSS to the parent element that also contains the rendered HTML
  let scoped_css = "@scope {" <> css.content <> "}"
  let preview =
    html.div([], [
      element.unsafe_raw_html("", "div", [], html.content),
      html.style([], scoped_css),
    ])

  custom_el.site_snippet_preview([], [snips, preview])
}
