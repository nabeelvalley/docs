import consts
import content/content
import gleam/list
import gleam/result
import lustre/element
import lustre/element/html
import rendering/assets.{Content, Dynamic, Meta, Page}
import rendering/pages/blog
import rendering/pages/docs
import rendering/pages/index
import rendering/pages/wip
import rendering/ssr/css_snippet
import rendering/ssr/gallery
import rendering/ssr/highlight
import rendering/ssr/html_snippet
import rendering/ssr/script_raw
import rendering/ssr/snippet
import rendering/templates/article

pub fn render(
  collection: content.Collection,
) -> Result(List(assets.RenderedPage), String) {
  use published_pages <- result.try(
    list.map(collection.pages |> list.filter(content.is_published), render_page)
    |> result.all,
  )
  use unpublished_pages <- result.try(
    list.map(
      collection.pages |> list.filter(content.is_unpublished),
      render_page,
    )
    |> result.all,
  )

  let index = index.render(published_pages) |> Dynamic
  let blog = blog.render(published_pages) |> Dynamic
  let docs = docs.render(published_pages) |> Dynamic
  let wip = wip.render(unpublished_pages) |> Dynamic

  let content_pages = published_pages |> list.map(Content)

  Ok([index, blog, docs, wip, ..content_pages])
}

fn render_page(doc: content.Page) {
  let meta =
    Meta(
      doc.frontmatter.title,
      doc.frontmatter.description,
      doc.frontmatter.date,
    )

  use processed <- result.try(
    Page(doc.path, doc.slug, meta, doc.html, [])
    |> chain([
      snippet.render_all,
      css_snippet.render_all,
      html_snippet.render_all,
      // highlight all code blocks (markdown or ssr)
      highlight.render_all,

      gallery.render_all,

      // rendered last to ensure that processors don't modify the result
      script_raw.render_all,
    ]),
  )

  let html =
    element.unsafe_raw_html(consts.html_namespace, "div", [], processed.html)
    |> article.render(meta)
    |> element.to_document_string

  Ok(Page(..processed, html:))
}

fn chain(base, processors) {
  list.try_fold(processors, base, fn(page, proc) { proc(page) })
}
