import gleam/list
import gleam/option.{None}
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, DynamicPage, Meta}
import rendering/templates/base

pub fn render(pages: List(Page)) {
  let meta = Meta("Docs", None, None)
  let html =
    pages
    |> list.filter(fn(p) { string.starts_with(p.slug, "/docs") })
    |> list.map(fn(p) {
      let slug = p.slug
      html.li([], [
        html.a([attribute.href(slug)], [
          html.text(p.meta.title),
        ]),
      ])
    })
    |> html.ul([], _)
    |> base.render(meta)
    |> element.to_document_string

  DynamicPage("docs", meta, html, [])
}
