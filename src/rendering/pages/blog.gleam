import content/frontmatter
import gleam/list
import gleam/option.{None}
import gleam/result
import mellie
import mellie/attr as attribute
import mellie/html
import rendering/assets.{DynamicPage, Meta}
import rendering/templates/base
import shoki
import shoki/date
import shoki/internal/fs

fn blog_path() {
  let assert Ok(blog_path) = fs.site_path_from_string("/blog")
  blog_path
}

pub fn render(pages: List(frontmatter.Frontmatter)) {
  let meta = Meta("Blog", None, None, [])
  let items =
    pages
    |> filter_and_sort
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

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], [html.ul([], items)])
    |> base.render(meta)

  fs.site_path_from_string("/blog.html")
  |> result.map(shoki.generated_html_file(_, html))
}

pub fn filter_and_sort(pages: List(frontmatter.Frontmatter)) {
  pages
  |> list.filter(fn(p) { fs.site_path_starts_with(p.path, blog_path()) })
  |> assets.sort_by_date
  |> list.reverse
}
