import content/fs
import gleam/list
import gleam/option.{None}
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, DynamicPage, Meta}
import rendering/templates/base
import util

pub fn render(pages: List(Page)) {
  let meta = Meta("Docs", None, None, [])

  let items =
    pages
    |> list.filter(fn(p) { string.starts_with(p.slug, "/docs") })
    |> list.group(fn(a) {
      case fs.split(a.slug) {
        [_empty, _docs, section, ..] -> section
        _ -> "other"
      }
    })
    |> util.dict_to_sorted_entries
    |> list.map(fn(entry) {
      let #(section, ps) = entry

      let title = section |> html.text

      let subitems =
        ps
        |> list.map(fn(p) {
          let slug = p.slug
          html.li([], [
            html.a([attribute.href(slug)], [
              html.text(p.meta.title),
            ]),
          ])
        })
        |> html.ul([], _)

      html.section([], [
        html.h2([], [title]),
        subitems,
      ])
    })

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], items)
    |> base.render(meta)
    |> element.to_document_string

  DynamicPage("/docs", meta, html, [])
}
