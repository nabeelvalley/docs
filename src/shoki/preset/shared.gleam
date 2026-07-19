import shoki/attr
import shoki/element
import shoki/html

pub fn page(body, title, css_path) {
  html.html([attr.lang("en")], [
    html.head([], [
      html.title([], [element.text(title)]),

      html.meta([attr.charset("UTF-8")]),
      html.meta([
        attr.name("viewport"),
        attr.content("width=device-width, initial-scale=1.0"),
      ]),

      html.link([
        attr.rel("icon"),
        attr.type_("image/x-icon"),
        attr.href("/favicon.png"),
      ]),

      html.link([
        attr.href(css_path),
        attr.rel("stylesheet"),
      ]),
      html.noscript([], [
        html.link([
          attr.href("/index.css"),
          attr.rel("stylesheet"),
        ]),
      ]),

      html.script(
        [
          attr.defer("true"),
          attr.type_("module"),
          attr.src("/index.js"),
        ],
        [
          element.raw_text(""),
        ],
      ),
    ]),
    body,
  ])
  |> element.to_html_document
}
