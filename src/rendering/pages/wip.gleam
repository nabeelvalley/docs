import gleam/list
import gleam/option.{None}
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, DynamicPage, Meta}
import rendering/templates/base

pub fn render(wip_pages: List(Page)) {
  let meta = Meta("Work in Progress", None, None)

  let html =
    wip_pages
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

  DynamicPage("wip", meta, html, [])
}
