import content/content
import content/md
import gleam/javascript/promise
import gleam/list
import gleam/option.{None}
import gleam/regexp
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/components/gallery
import rendering/components/snippet
import rendering/layout

const html_namespace = "http://www.w3.org/1999/xhtml"

pub type Page {
  Page(slug: String, meta: layout.Meta, html: String)
}

pub fn render(collection: content.Collection) {
  let blog = collection.blog |> list.map(render_md_page("blog", _))
  let docs = collection.docs |> list.map(render_md_page("docs", _))
  let talks = collection.talks |> list.map(render_md_page("talks", _))

  let md_page_tasks =
    []
    |> list.append(blog)
    |> list.append(docs)
    |> list.append(talks)
    |> promise.await_list

  use md_pages <- promise.await(md_page_tasks)

  use index <- promise.await(render_index(md_pages))

  [index, ..md_pages] |> promise.resolve
}

fn to_slug(base: String, rel: String) {
  let assert Ok(re) = regexp.from_string("\\.\\w+$")

  base <> "/" <> regexp.replace(re, rel, "")
}

fn render_index(pages: List(Page)) {
  let meta = layout.Meta(None, None, None)
  let html =
    pages
    |> list.map(fn(p) {
      html.li([], [
        html.a([attribute.href(p.slug)], [
          html.text(option.unwrap(p.meta.title, p.slug)),
        ]),
      ])
    })
    |> html.ul([], _)
    |> layout.page(meta)
    |> element.to_document_string

  Page("index", meta, html) |> promise.resolve
}

fn render_md_page(base: String, doc: md.MarkdownDocument) {
  let content =
    doc.html
    |> element.unsafe_raw_html(html_namespace, "div", [], _)

  let meta =
    layout.Meta(
      doc.frontmatter.title,
      doc.frontmatter.description,
      doc.frontmatter.date,
    )

  let html_task =
    html.main([], [content])
    |> layout.page(meta)
    |> element.to_document_string
    |> snippet.render_all
    |> promise.await(gallery.render_all)

  let slug = to_slug(base, doc.path)

  use html <- promise.await(html_task)

  Page(slug, meta, html) |> promise.resolve
}
