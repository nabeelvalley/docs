import consts
import content/content
import content/frontmatter
import date
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option
import gleam/result
import lustre/element
import rendering/assets.{Content, Dynamic, Meta, Page}
import rendering/pages/blog
import rendering/pages/docs
import rendering/pages/index
import rendering/pages/photography
import rendering/pages/talks
import rendering/pages/wip
import rendering/ssr/css_snippet
import rendering/ssr/gallery
import rendering/ssr/highlight
import rendering/ssr/html_snippet
import rendering/ssr/script_raw
import rendering/ssr/snippet
import rendering/templates/article
import util

pub fn render(
  collection: content.Collection,
) -> Promise(Result(List(assets.RenderedPage), String)) {
  use published_pages <- promise.try_await(
    list.map(collection.pages |> list.filter(content.is_published), render_page)
    |> promise.await_list
    |> promise.map(result.all),
  )

  use unpublished_pages <- promise.try_await(
    list.map(
      collection.pages |> list.filter(content.is_unpublished),
      render_page,
    )
    |> promise.await_list
    |> promise.map(result.all),
  )

  let index = index.render(published_pages) |> Dynamic
  let blog = blog.render(published_pages) |> Dynamic
  let docs = docs.render(published_pages) |> Dynamic
  let talks = talks.render(published_pages) |> Dynamic
  let photography = photography.render(published_pages) |> Dynamic

  let wip = wip.render(unpublished_pages) |> Dynamic

  let content_pages = published_pages |> list.map(Content)

  Ok([index, blog, docs, talks, photography, wip, ..content_pages])
  |> promise.resolve
}

fn render_page(doc: content.Page) -> Promise(Result(assets.Page, String)) {
  let meta =
    Meta(
      doc.frontmatter.title,
      doc.frontmatter.description,
      doc.slug |> date.parse_from_path |> option.from_result,
    )

  case doc.frontmatter.layout {
    frontmatter.NoLayout ->
      Ok(Page(doc.path, doc.slug, meta, doc.html, [])) |> promise.resolve
    _ ->
      promise.try_await(
        Page(doc.path, doc.slug, meta, doc.html, [])
          |> util.try_resolve_chain([
            promisify(snippet.render_all),
            promisify(css_snippet.render_all),
            promisify(html_snippet.render_all),

            // // highlight all code blocks (markdown or ssr)
            highlight.render_all,
            promisify(gallery.render_all),

            // // rendered last to ensure that processors don't modify the result
            promisify(script_raw.render_all),
          ]),
        fn(processed) {
          let html =
            element.unsafe_raw_html(
              consts.html_namespace,
              "div",
              [],
              processed.html,
            )
            |> article.render(meta)
            |> element.to_document_string

          Ok(Page(..processed, html:)) |> promise.resolve
        },
      )
  }
}

fn promisify(f: fn(a) -> b) -> fn(a) -> Promise(b) {
  fn(arg: a) { f(arg) |> promise.resolve }
}
