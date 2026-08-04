import gleam/option.{None, Some}
import gleam/result
import mellie
import mellie/html
import rendering/ssr/custom_el
import rendering/ssr/snippet
import charge/component
import charge/error
import charge/fs

pub fn component() {
  component.new("htmlsnippet", fn(data, el) {
    case data.source_path {
      None -> el |> Ok
      Some(source) -> {
        use path <- result.try(
          mellie.attr(el, "path")
          |> result.replace_error(error.ComponentError(
            "could not read path for snippet",
          )),
        )

        use #(resolved, code) <- result.try(snippet.load(source, path))

        render(resolved, path, code)
      }
    }
  })
}

fn render(file: fs.Path, title: String, code: String) {
  use parsed <- result.map(
    mellie.parse(code)
    |> result.replace_error(error.ComponentError(
      "Error parsing html for html snippet: " <> file |> fs.path_to_string,
    )),
  )

  let snip = snippet.render(file, title, code)
  custom_el.site_snippet_preview([], [snip, html.div([], [parsed])])
}
