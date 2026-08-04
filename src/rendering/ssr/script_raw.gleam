import gleam/option.{None, Some}
import gleam/result
import mellie
import mellie/html
import rendering/ssr/snippet
import charge/component
import charge/error

pub fn component() {
  component.new("script-raw", fn(data, el) {
    case data.source_path {
      None -> el |> Ok
      Some(source) -> {
        use path <- result.try(
          mellie.attr(el, "path")
          |> result.replace_error(error.ComponentError(
            "could not read path for snippet",
          )),
        )

        use #(_, code) <- result.map(snippet.load(source, path))

        render(code, el |> mellie.attrs)
      }
    }
  })
}

fn render(code: String, attrs) {
  html.script(attrs, [code |> mellie.text])
}
