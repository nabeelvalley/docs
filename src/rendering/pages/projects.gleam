import charge
import charge/fs
import content/metadata.{type Project, External, Internal}
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import mellie/attr as attribute
import mellie/html
import rendering/templates/base

fn projects_file() {
  let assert Ok(path) = fs.site_path_from_string("/projects.html")
  path
}

fn paragraphs(str) {
  str
  |> string.split("\n")
  |> list.map(fn(p) { html.p([], [html.text(p)]) })
}

fn link(title, l) {
  let href = case l {
    Internal(p) -> fs.site_path_to_href(p)
    External(p) -> attribute.href(p)
  }

  html.a([href], [html.text(title)])
}

pub fn project_link(project: Project) {
  link(project.title, project.link)
}

fn img(title, i) {
  case i {
    None -> []
    Some(p) -> [
      html.img([fs.site_path_to_src(p), attribute.alt(title <> " screenshot")]),
    ]
  }
}

pub fn render(_) {
  let meta = base.Meta("projects", None, None, [])
  let projects = metadata.load_projects()

  let items =
    projects
    |> list.map(fn(p) {
      let elems =
        [
          html.h2([], [link(p.title, p.link)]),
        ]
        |> list.append(img(p.title, p.image))
        |> list.append(paragraphs(p.description))

      html.section([], elems)
    })

  let html =
    // temp until we figure out how this layout should look
    html.article([attribute.class("site-article")], [
      html.h1([], [html.text("Projects")]),
      ..items
    ])
    |> base.render(meta)

  charge.generated_html_file(projects_file(), html) |> Ok
}
