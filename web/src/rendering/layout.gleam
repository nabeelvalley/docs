import content/md
import gleam/option
import lustre/attribute
import lustre/element/html

const base_title = "Nabeel Valley"

const base_description = "Software develpment, Photography and Design"

pub fn page(frontmatter: md.Frontmatter, body) {
  let title = case frontmatter.title {
    option.Some(t) -> t <> " - " <> base_title
    option.None -> base_title
  }

  let description = option.unwrap(frontmatter.description, base_description)

  html.html([], [
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
    ]),
    body,
  ])
}
