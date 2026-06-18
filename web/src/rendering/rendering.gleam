import content/content
import content/md
import gleam/list
import gleam/regexp
import lustre/element
import lustre/element/html
import mork/to_lustre
import rendering/layout

pub type Page {
  Page(slug: String, html: String)
}

pub fn render(collection: content.Collection) {
  let blog = collection.blog |> list.map(render_page("blog", _))
  let docs = collection.docs |> list.map(render_page("docs", _))

  let pages = [] |> list.append(blog) |> list.append(docs)

  pages
}

fn to_slug(base: String, rel: String) {
  let assert Ok(re) = regexp.from_string("\\.\\w+$")

  base <> "/" <> regexp.replace(re, rel, "")
}

fn render_page(base: String, doc: md.MarkdownDocument) {
  let content = to_lustre.to_lustre(doc.doc)

  let main = html.main([], content)
  let html = layout.page(doc.frontmatter, main) |> element.to_document_string

  let slug = to_slug(base, doc.path)

  Page(slug, html)
}
