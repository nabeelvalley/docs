import date
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, DynamicPage, Meta}
import rendering/templates/base

pub fn render(pages: List(Page)) {
  let meta = Meta("Blog", None, None)
  let items =
    pages
    |> filter_and_sort
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

  DynamicPage("/blog", meta, html, [])
}

pub fn filter_and_sort(pages: List(Page)) {
  pages
  |> list.filter(fn(p) { string.starts_with(p.slug, "/blog") })
  |> list.sort(fn(a, b) {
    case a.meta.date, b.meta.date {
      Some(a), Some(b) -> date.compare(a, b)
      Some(_), _ -> order.Gt
      None, _ -> order.Lt
    }
  })
  |> list.reverse
}
