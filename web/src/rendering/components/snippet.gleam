import consts
import content/fs
import gleam/dict
import gleam/javascript/promise.{type Promise}
import gleam/result
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html

pub fn render_all(html: String) -> Promise(String) {
  use _, raw_attrs <- dom.update(html:, tag: "snippet")
  let attrs = dict.from_list(raw_attrs)

  {
    use path <- result.try(dict.get(attrs, "path"))

    let full_path = fs.join([consts.snippets_dir, path])
    let read_file =
      fs.read_file(full_path, consts.snippets_dir) |> result.replace_error(Nil)

    use file <- result.try(read_file)

    Ok(render(file.relative, file.content))
  }
  |> result.unwrap(element.none())
  |> element.to_document_string
  |> promise.resolve
}

fn render(title: String, code: String) {
  let lang = fs.ext(title)

  html.figure([attribute.class("snippet")], [
    html.figcaption([], [html.text(title)]),

    html.pre([], [
      html.code([attribute.class("language-" <> lang)], [
        html.text(code),
      ]),
    ]),
  ])
}
