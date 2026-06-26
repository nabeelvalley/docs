import consts
import content/content
import content/md
import gleam/list
import gleam/option.{None}
import gleam/regexp
import gleam/result
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Meta, Page}
import rendering/components/gallery
import rendering/components/snippet
import rendering/layout

pub fn render(collection: content.Collection) -> Result(List(Page), String) {
  let blog = collection.blog |> list.map(render_md_page("blog", _))
  let docs = collection.docs |> list.map(render_md_page("docs", _))
  let talks = collection.talks |> list.map(render_md_page("talks", _))

  let md_pages_result =
    []
    |> list.append(blog)
    |> list.append(docs)
    |> list.append(talks)
    |> result.all

  use md_pages <- result.try(md_pages_result)
  let index = render_index(md_pages)

  [index] |> list.append(md_pages) |> Ok
}

fn to_slug(base: String, rel: String) {
  let assert Ok(re) = regexp.from_string("\\.\\w+$")

  base <> "/" <> regexp.replace(re, rel, "")
}

fn render_index(pages: List(Page)) {
  let meta = Meta(None, None, None)
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

  Page("index", meta, html, [])
}

fn render_md_page(base: String, doc: md.MarkdownDocument) {
  let meta =
    Meta(
      doc.frontmatter.title,
      doc.frontmatter.description,
      doc.frontmatter.date,
    )

  let slug = to_slug(base, doc.path)

  use processed <- result.try(
    Page(slug, meta, doc.html, [])
    |> process_page([
      snippet.render_all,
      gallery.render_all,
    ]),
  )

  let html =
    html.main([], [
      element.unsafe_raw_html(
        consts.html_namespace,
        "article",
        [],
        processed.html,
      ),
    ])
    |> layout.page(meta)
    |> element.to_document_string

  Ok(Page(..processed, html:))
}

fn process_page(base, processors) {
  list.try_fold(processors, base, fn(page, proc) { proc(page) })
}
