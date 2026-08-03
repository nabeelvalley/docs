import gleam/javascript/promise
import gleam/result
import mellie
import mellie/attr
import mellie/html
import shoki
import shoki/component
import shoki/error
import shoki/internal/shiki

fn highlight(pre) {
  let lang = get_lang(pre)

  let code =
    pre
    |> mellie.inner_text

  shiki.highlight(code, lang)
  |> promise.map_try(mellie.parse)
  |> promise.map(result.map_error(_, error.SyntaxHighlightingError))
  |> promise.map_try(render(_, lang))
}

fn get_lang(pre) {
  let lang =
    pre
    |> mellie.get_child_by_tag("code")
    |> result.try(mellie.attr(_, "class"))
    |> result.unwrap("text")

  case lang {
    "language-" <> l -> l
    _ -> lang
  }
}

fn figure(pre) {
  html.figure([attr.class("codeblock")], [pre])
}

fn render(highlighted, lang) {
  mellie.get_child_by_tag(highlighted, "pre")
  |> result.map(mellie.set_attribute(_, attr.lang(lang)))
  |> result.map(figure)
  |> result.replace_error(error.SyntaxHighlightingError(
    "Could not find pre tag in highlighted content",
  ))
}

pub fn with_syntax_highlighting(pipeline) {
  pipeline
  |> shoki.with_async_component(
    component.new("pre", fn(_, pre) { fn() { highlight(pre) } }),
  )
}
