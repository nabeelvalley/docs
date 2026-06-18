import content/content
import content/md
import gleam/list
import gleam/regexp
import lustre/element
import lustre/element/html
import mork
import rendering/layout

pub type Page {
  Page(slug: String, html: String)
}

pub fn render(collection: content.Collection) {
  let blog = collection.blog |> list.map(render_page("blog", _))
  let docs = collection.docs |> list.map(render_page("docs", _))
  let talks = collection.talks |> list.map(render_page("talks", _))

  let pages = [] |> list.append(blog) |> list.append(docs) |> list.append(talks)

  pages
}

fn to_slug(base: String, rel: String) {
  let assert Ok(re) = regexp.from_string("\\.\\w+$")

  base <> "/" <> regexp.replace(re, rel, "")
}

fn render_page(base: String, doc: md.MarkdownDocument) {
  let content =
    mork.to_html(doc.doc)
    |> element.unsafe_raw_html("http://www.w3.org/1999/xhtml", "div", [], _)

  let main = html.main([], [content])
  let html = layout.page(doc.frontmatter, main) |> element.to_document_string

  let slug = to_slug(base, doc.path)

  Page(slug, html)
}
