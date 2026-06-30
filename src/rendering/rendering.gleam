import consts
import content/content
import gleam/list
import gleam/option.{None}
import gleam/regexp
import gleam/result
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Meta, Page}
import rendering/components/css_snippet
import rendering/components/gallery
import rendering/components/html_snippet
import rendering/components/script_raw
import rendering/components/snippet
import rendering/layout

pub fn render(collection: content.Collection) -> Result(List(Page), String) {
  use pages <- result.try(list.map(collection.pages, render_page) |> result.all)

  let index = render_index(pages)

  Ok([index, ..pages])
}

fn to_slug(rel: String) {
  let assert Ok(re) = regexp.from_string("\\.\\w+$")

  "/" <> regexp.replace(re, rel, "")
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

  Page("", "index", meta, html, [])
}

fn render_page(doc: content.Page) {
  let meta =
    Meta(
      doc.frontmatter.title,
      doc.frontmatter.description,
      doc.frontmatter.date,
    )

  let slug = to_slug(doc.relative)

  use processed <- result.try(
    Page(doc.path, slug, meta, doc.html, [])
    |> process_page([
      snippet.render_all,
      css_snippet.render_all,
      html_snippet.render_all,
      gallery.render_all,

      // rendered last to ensure that processors don't modify the result
      script_raw.render_all,
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
