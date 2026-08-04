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
  component.new("csssnippet", fn(data, el) {
    case data.source_path {
      None -> el |> Ok
      Some(source) -> {
        use css_path <- result.try(
          mellie.attr(el, "path")
          |> result.replace_error(error.ComponentError(
            "could not read path for snippet",
          )),
        )
        use html_path <- result.try(
          mellie.attr(el, "htmlpath")
          |> result.replace_error(error.ComponentError(
            "could not read path for snippet",
          )),
        )

        use #(html_source, html_code) <- result.try(snippet.load(
          source,
          html_path,
        ))

        use #(css_source, css_code) <- result.try(snippet.load(source, css_path))

        let show_html =
          mellie.attr(el, "html")
          |> result.replace(True)
          |> result.unwrap(False)

        render(
          css_path,
          css_source,
          css_code,
          html_path,
          html_source,
          html_code,
          show_html,
        )
      }
    }
  })
}

pub fn render(
  css_path,
  css: fs.Path,
  css_code,
  html_path,
  html: fs.Path,
  html_code,
  show_html: Bool,
) {
  use parsed <- result.map(
    mellie.parse(html_code)
    |> result.replace_error(error.ComponentError(
      "error parsing html in csssnippet:" <> html_path,
    )),
  )

  let css_snip = snippet.render(css, css_path, css_code)
  let html_snip = snippet.render(html, html_path, html_code)

  let snips = case show_html {
    True -> html.div([], [css_snip, html_snip])
    False -> css_snip
  }

  // uses https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@scope
  // to scope the CSS to the parent element that also contains the rendered HTML
  let scoped_css = "@scope {" <> css_code <> "}"

  let preview =
    html.div([], [
      parsed,
      html.style([], [scoped_css |> mellie.text]),
    ])

  custom_el.site_snippet_preview([], [snips, preview])
}
