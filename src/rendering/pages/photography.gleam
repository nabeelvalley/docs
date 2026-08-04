import content/frontmatter
import gleam/dict
import gleam/list
import gleam/option.{None}
import gleam/result
import mellie/attr as attribute
import mellie/html
import rendering/dict as dict_util
import rendering/templates/base
import shoki
import shoki/internal/fs

fn photography_path() {
  let assert Ok(path) = fs.site_path_from_string("/photography")
  path
}

pub fn render(pages: List(frontmatter.Frontmatter)) {
  let meta = base.Meta("Photography", None, None, [])
  let photography_items =
    pages
    |> list.filter(fn(p) {
      fs.site_path_starts_with(p.path, photography_path())
    })
    |> list.group(fn(a) {
      case fs.site_path_parts(a.path) {
        [_photography, section, ..] -> section
        _ -> "other"
      }
    })

  let tag_items =
    pages
    |> list.filter(fn(p) { p.tags |> list.contains("photography") })
    |> list.group(fn(a) {
      case fs.site_path_parts(a.path) {
        [section, ..] -> section
        _ -> "other"
      }
    })

  let all_items = dict.combine(photography_items, tag_items, list.append)

  let rendered =
    all_items
    |> dict_util.to_sorted_entries
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
    html.article([attribute.class("site-article")], rendered)
    |> base.render(meta)

  fs.site_path_from_string("/photography.html")
  |> result.map(shoki.generated_html_file(_, html))
}
