import consts
import content/content
import content/fs
import content/md
import gleam/dict
import gleam/list
import gleam/regexp
import gleam/result
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import mork
import rendering/layout

const html_namespace = "http://www.w3.org/1999/xhtml"

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
    |> element.unsafe_raw_html(html_namespace, "div", [], _)

  let main = html.main([], [content])
  let html =
    layout.page(doc.frontmatter, main)
    |> element.to_document_string
    |> render_snippet

  let slug = to_slug(base, doc.path)

  Page(slug, html)
}

fn render_snippet(html: String) -> String {
  use _, raw_attrs <- dom.update(html:, tag: "snippet")
  let attrs = dict.from_list(raw_attrs)

  {
    use path <- result.try(dict.get(attrs, "path"))

    let full_path = fs.join([consts.snippets_dir, path])
    let read_file =
      fs.read_file(full_path, consts.snippets_dir) |> result.replace_error(Nil)

    use file <- result.try(read_file)

    let lang = fs.ext(file.relative)

    Ok(
      html.figure([attribute.class("snippet")], [
        html.figcaption([], [html.text(file.relative)]),

        html.pre([], [
          html.code([attribute.class("language-" <> lang)], [
            html.text(file.content),
          ]),
        ]),
      ]),
    )
  }
  |> result.unwrap(element.none())
  |> element.to_document_string
}
