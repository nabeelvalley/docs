import content/frontmatter
import gleam/list
import gleam/option.{None}
import gleam/string
import mellie
import mellie/attr as attribute
import mellie/html
import rendering/assets.{DynamicPage, Meta}
import rendering/templates/base
import shoki/date
import shoki/internal/fs

pub fn render(pages: List(frontmatter.Frontmatter)) {
  let meta = Meta("Talks", None, None, [])
  let items =
    pages
    |> list.filter(fn(p) {
      string.starts_with(p.path |> fs.site_path_to_string, "/talks")
    })
    |> assets.sort_by_date
    |> list.reverse
    |> list.map(fn(p) {
      let slug = p.path |> fs.site_path_to_string
      let date = case p.date {
        option.Some(d) -> d |> date.to_string(".")
        None -> "date unknown"
      }

      html.li([], [
        html.a([attribute.href(slug)], [
          html.text(date <> " - " <> p.title),
        ]),
      ])
    })

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], [html.ul([], items)])
    |> base.render(meta)
    |> mellie.to_document_string

  DynamicPage("/talks", meta, html, [])
}
