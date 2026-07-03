import consts
import gleam/option
import lustre/attribute
import lustre/element/html
import rendering/assets.{type Meta}
import rendering/templates/footer
import rendering/templates/header

pub fn render(body, meta: Meta) {
  let title = case meta.title {
    option.Some(t) -> t <> " - " <> consts.site_title
    option.None -> consts.site_title
  }

  let description = option.unwrap(meta.description, consts.site_description)

  html.html([attribute.lang("en")], [
    html.head([], [
      html.title([], title),

      html.meta([attribute.charset("UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1.0"),
      ]),
      html.meta([
        attribute.name("description"),
        attribute.content(description),
      ]),
      html.meta([
        attribute.name("og:description"),
        attribute.content(description),
      ]),
      html.meta([
        attribute.name("og:image"),
        attribute.content("https://nabeelvalley.co.za/images/home/code.jpg"),
      ]),
      html.meta([attribute.name("og:title"), attribute.content(title)]),

      html.link([
        attribute.rel("webmention"),
        attribute.href("https://webmention.io/nabeelvalley.co.za/webmention"),
      ]),

      html.link([attribute.rel("stylesheet"), attribute.href("/index.css")]),
      html.script(
        [
          attribute.attribute("defer", "true"),
          attribute.type_("module"),
          attribute.src("/index.js"),
        ],
        "",
      ),
    ]),
    header.render(),
    body,
    footer.render(),
  ])
}
