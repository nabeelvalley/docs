import argv
import clip
import clip/flag
import content/frontmatter
import gleam/io
import gleam/javascript/promise
import gleam/result
import mellie
import rendering/assets
import rendering/ssr/custom_el
import rendering/templates/article
import shoki
import shoki/error
import shoki/internal/fs
import shoki/markdown

pub fn pipeline() {
  let assert Ok(out) = fs.from_cwd("./out")
  let assert Ok(public) = fs.from_cwd("./public")
  let assert Ok(md) = fs.from_cwd("./content/pages")

  markdown.from_markdown(
    out: out,
    dir: md,
    decode: frontmatter.decoder,
    agg: fn(frontmatters) { frontmatters },
    render: fn(file, _frontmatters) {
      use md <- result.map(markdown.render(file))
      let fm = file |> markdown.frontmatter
      let meta = assets.Meta(fm.title, fm.description, fm.date, fm.tags)

      // TODO: Replace this once we've got fragments
      md |> mellie.children |> custom_el.site_markdown |> article.render(meta)
    },
  )
  |> shoki.with_static_dir(public)
}

pub fn main() {
  let cmd =
    clip.command({
      // to be used for running axe linting once pages are rendered
      use _report <- clip.parameter

      pipeline() |> shoki.run()
    })
    |> clip.flag(
      flag.new("report") |> flag.help("run a11y and link-checking reports"),
    )

  let result = cmd |> clip.run(argv.load().arguments)

  case result {
    Error(err) -> io.println_error(err) |> promise.resolve
    Ok(cmd_result) -> {
      use cmd_resolved <- promise.await(cmd_result)
      case cmd_resolved {
        Ok(_) -> io.println("Pipeline run successfully")
        Error(err) -> io.println_error(err |> error.error_to_string)
      }
      |> promise.resolve
    }
  }
}
