import charge
import charge/date
import charge/fs
import content/metadata
import gleam/list
import gleam/option.{None}
import gleam/result
import mellie/attr as attribute
import mellie/html
import rendering/pages/blog
import rendering/pages/projects
import rendering/templates/base

pub fn render(pages: List(metadata.Frontmatter)) {
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

  let recent_projects =
    metadata.load_projects()
    |> list.take(10)
    |> list.map(fn(p) {
      html.li([], [
        projects.project_link(p),
        html.text(" - " <> p.description),
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
          "I'm Nabeel and you've found your way to my little space on the internet. I hope you enjoy your stay!",
        ),
      ]),
      html.h2([], [
        html.text("What I'm Thinking About"),
      ]),
      recent_blogs,
      html.p([], [html.a([attribute.href("/blog")], [html.text("All posts")])]),
      html.h2([], [
        html.text("What I'm Working On"),
      ]),
      recent_projects,
      html.p([], [
        html.a([attribute.href("/projects")], [html.text("All projects")]),
      ]),
    ])
    |> base.render(meta)

  fs.site_path_from_string("/index.html")
  |> result.map(charge.generated_html_file(_, html))
}
