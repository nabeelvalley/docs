import content/frontmatter
import gleam/list
import gleam/option.{None}
import mellie/attr as attribute
import mellie/html
import rendering/templates/base
import charge
import charge/date
import charge/internal/fs

fn talks_path() {
  let assert Ok(path) = fs.site_path_from_string("/talks")
  path
}

fn talks_file() {
  let assert Ok(path) = fs.site_path_from_string("/talks.html")
  path
}

pub fn render(pages: List(frontmatter.Frontmatter)) {
  let meta = base.Meta("Talks", None, None, [])
  let items =
    pages
    |> list.filter(fn(p) { fs.site_path_starts_with(p.path, talks_path()) })
    |> frontmatter.sort_by_date
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

  charge.generated_html_file(talks_file(), html) |> Ok
}
