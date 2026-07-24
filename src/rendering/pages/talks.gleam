import gleam/list
import gleam/option.{None}
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, DynamicPage, Meta}
import rendering/templates/base
import shoki/date

pub fn render(pages: List(Page)) {
  let meta = Meta("Talks", None, None, [])
  let items =
    pages
    |> list.filter(fn(p) { string.starts_with(p.slug, "/talks") })
    |> assets.sort_by_date
    |> list.reverse
    |> list.map(fn(p) {
      let slug = p.slug
      let date = case p.meta.date {
        option.Some(d) -> d |> date.to_string(".")
        None -> "date unknown"
      }

      html.li([], [
        html.a([attribute.href(slug)], [
          html.text(date <> " - " <> p.meta.title),
        ]),
      ])
    })

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], [html.ul([], items)])
    |> base.render(meta)
    |> element.to_document_string

  DynamicPage("/talks", meta, html, [])
}
