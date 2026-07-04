import lustre/attribute.{class, href}
import lustre/element/html.{a, input, label, li, nav, text, ul}

pub fn render() {
  nav([class("site-nav")], [
    ul([], [
      li([], [a([href("/blog")], [text("Blog")])]),
      li([], [a([href("/docs")], [text("Docs")])]),
      li([], [
        a([href("/projects")], [text("Projects")]),
      ]),
      li([], [a([href("/talks")], [text("Talks")])]),
      li([], [
        a([href("/photography")], [text("Photography")]),
      ]),
      li([], [a([href("/archive")], [text("Archive")])]),
      li([], [a([href("/about")], [text("Me")])]),
    ]),
  ])
}
