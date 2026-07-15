import lustre/attribute
import lustre/element/html

pub fn page(body, title, css_path) {
  html.html([attribute.lang("en")], [
    html.head([], [
      html.title([], title),

      html.meta([attribute.charset("UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1.0"),
      ]),

      html.link([
        attribute.rel("icon"),
        attribute.type_("image/x-icon"),
        attribute.href("/favicon.png"),
      ]),

      html.link([
        attribute.href(css_path),
        attribute.rel("stylesheet"),
      ]),
      html.noscript([], [
        html.link([
          attribute.href("/index.css"),
          attribute.rel("stylesheet"),
        ]),
      ]),

      html.script(
        [
          attribute.attribute("defer", "true"),
          attribute.type_("module"),
          attribute.src("/index.js"),
        ],
        "",
      ),
    ]),
    body,
  ])
}
