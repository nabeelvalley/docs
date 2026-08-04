import content/frontmatter
import gleam/list
import gleam/option.{None}
import gleam/result
import mellie/attr as attribute
import mellie/html
import rendering/pages/blog
import rendering/templates/base
import charge
import charge/date
import charge/internal/fs

pub fn render(pages: List(frontmatter.Frontmatter)) {
  let meta = base.Meta("Home", None, None, [])
  let recent_blogs =
    blog.filter_and_sort(pages)
    |> list.take(10)
    |> list.map(fn(p) {
      let date = case p.date {
        option.Some(d) -> d |> date.to_string(".")
        None -> "date unknown"
      }

      html.li([], [
        html.a([fs.site_path_to_href(p.path)], [
          html.text(date <> " - " <> p.title),
        ]),
      ])
    })
    |> html.ul([], _)

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], [
      html.h1([], [
        html.text("Hi there!"),
      ]),
      html.p([], [
        html.text(
          "Welcome to the 7th iteration of my website. This version is in active development as of 7 July 2026 so expect some stuff to be missing.",
        ),
      ]),
      html.p([], [
        html.text(
          "Feel free to browse around in the meantime - some pages might be a little wonky but hopefully the kinks will be worked out in the coming weeks.",
        ),
      ]),
      html.p([], [
        html.text(
          "Until everything is sorted though - why not look at some of my recent posts:",
        ),
      ]),
      recent_blogs,
    ])
    |> base.render(meta)

  fs.site_path_from_string("/index.html")
  |> result.map(charge.generated_html_file(_, html))
}
