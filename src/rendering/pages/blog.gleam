import charge
import charge/date
import charge/fs
import content/metadata
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None}
import gleam/result
import mellie/attr as attribute
import mellie/html
import rendering/templates/base

fn blog_path() {
  let assert Ok(blog_path) = fs.site_path_from_string("/blog")
  blog_path
}

pub fn render(pages: List(metadata.Frontmatter)) {
  let meta = base.Meta("Blog", None, None, [])
  let sections =
    pages
    |> group_by_year
    |> dict.map_values(fn(year, pages) {
      let items =
        pages
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

      html.section([], [
        html.h2([], [
          year
          |> option.map(int.to_string)
          |> option.unwrap("year unknown")
          |> html.text,
        ]),

        html.ul([], items),
      ])
    })
    |> dict.values

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], [
      html.h1([], [html.text("Blog")]),
      ..sections
    ])
    |> base.render(meta)

  fs.site_path_from_string("/blog.html")
  |> result.map(charge.generated_html_file(_, html))
}

fn is_published_blog_post(p: metadata.Frontmatter) {
  p.published && fs.site_path_starts_with(p.path, blog_path())
}

fn group_by_year(pages: List(metadata.Frontmatter)) {
  pages
  |> list.filter(is_published_blog_post)
  |> list.group(fn(p) { p.date |> option.map(fn(d) { d.year }) })
  |> dict.map_values(fn(_, v) { v |> filter_and_sort })
}

pub fn filter_and_sort(pages: List(metadata.Frontmatter)) {
  pages
  |> list.filter(is_published_blog_post)
  |> metadata.sort_by_date
  |> list.reverse
}
