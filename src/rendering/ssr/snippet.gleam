import consts
import gleam/option.{None, Some}
import gleam/result
import mellie
import mellie/attr as attribute
import mellie/html
import shoki/component
import shoki/error
import shoki/internal/fs

fn snippets_dir() {
  let assert Ok(dir) = fs.from_cwd(consts.snippets_dir)
  dir
}

pub fn component() {
  component.new("snippet", fn(data, el) {
    case data.source_path {
      None -> el |> Ok
      Some(source) -> {
        use path <- result.try(
          mellie.attr(el, "path")
          |> result.replace_error(error.ComponentError(
            "could not read path for snippet",
          )),
        )

        use #(resolved, code) <- result.map(load(source, path))

        render(resolved, path, code)
      }
    }
  })
}

pub fn load(from_file: fs.Path, path: String) {
  use full_path <- result.try(case path {
    "." <> _ -> {
      use parent <- result.try(fs.parent(from_file))
      fs.resolve(parent, path)
    }
    _ -> fs.resolve(snippets_dir(), path)
  })

  use content <- result.map(fs.read_text_file(full_path))

  #(full_path, content)
}

pub fn render(file: fs.Path, title: String, code: String) {
  let lang = fs.ext(file) |> result.unwrap("text")

  html.figure([attribute.class("snippet")], [
    html.figcaption([], [html.text(title)]),

    html.pre([], [
      html.code([attribute.class("language-" <> lang)], [
        html.text(code),
      ]),
    ]),
  ])
}
