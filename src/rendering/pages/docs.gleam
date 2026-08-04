import content/frontmatter
import gleam/list
import gleam/option.{None}
import mellie/attr as attribute
import mellie/html
import rendering/dict
import rendering/templates/base
import charge
import charge/internal/fs

fn docs_path() {
  let assert Ok(path) = fs.site_path_from_string("/docs")
  path
}

fn docs_file() {
  let assert Ok(path) = fs.site_path_from_string("/docs.html")
  path
}

pub fn render(pages: List(frontmatter.Frontmatter)) {
  let meta = base.Meta("Docs", None, None, [])

  let items =
    pages
    |> list.filter(fn(p) { fs.site_path_starts_with(p.path, docs_path()) })
    |> list.group(fn(a) {
      case fs.site_path_parts(a.path) {
        [_docs, section, ..] -> section
        _ -> "other"
      }
    })
    |> dict.to_sorted_entries
    |> list.map(fn(entry) {
      let #(section, ps) = entry

      let title = section |> html.text

      let subitems =
        ps
        |> list.map(fn(p) {
          html.li([], [
            html.a([fs.site_path_to_href(p.path)], [
              html.text(p.title),
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

  charge.generated_html_file(docs_file(), html) |> Ok
}
