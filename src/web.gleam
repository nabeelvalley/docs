import argv
import clip
import clip/flag
import consts
import content/frontmatter
import gleam/io
import gleam/javascript/promise
import gleam/list
import gleam/option
import mellie
import rendering/pages/blog
import rendering/pages/docs
import rendering/pages/index
import rendering/pages/photography
import rendering/pages/talks
import rendering/ssr/css_snippet
import rendering/ssr/custom_el
import rendering/ssr/gallery
import rendering/ssr/html_snippet
import rendering/ssr/script_raw
import rendering/ssr/snippet
import rendering/templates/article
import rendering/templates/base
import charge
import charge/error
import charge/highlight
import charge/image
import charge/fs
import charge/rss

import charge/markdown

pub fn pipeline() {
  let assert Ok(out) = fs.from_cwd(consts.out_dir)
  let assert Ok(public) = fs.from_cwd(consts.public_dir)
  let assert Ok(md) = fs.from_cwd(consts.content_dir)

  markdown.from_markdown(
    out: out,
    dir: md,
    decode: frontmatter.decoder,
    agg: list.filter(_, frontmatter.is_published),
    render: fn(file, _frontmatters) {
      let content = file |> markdown.content
      let fm = file |> markdown.frontmatter

      let meta = base.Meta(fm.title, fm.description, fm.date, fm.tags)

      content
      |> mellie.children
      |> custom_el.site_markdown
      |> article.render(meta)
      |> Ok
    },
  )
  |> charge.with_asset(index.render)
  |> charge.with_asset(blog.render)
  |> charge.with_asset(photography.render)
  |> charge.with_asset(docs.render)
  |> charge.with_asset(talks.render)
  |> charge.with_components([
    gallery.component(),
    snippet.component(),
    html_snippet.component(),
    css_snippet.component(),
    script_raw.component(),
  ])
  |> highlight.with_syntax_highlighting
  |> image.with_image_optimization(fs.cwd())
  |> image.with_image_optimization(public)
  |> rss.with_rss(
    rss.RSSFeed(
      consts.site_title,
      consts.site_description,
      consts.site_base_url,
    ),
    to_rss_item,
  )
  |> charge.with_static_dir(public)
}

fn to_rss_item(
  frontmatters: List(frontmatter.Frontmatter),
  file: charge.HTMLFile,
) {
  let found = frontmatters |> list.find(fn(i) { i.path == file.path })

  found
  |> option.from_result
  |> option.map(fn(fm) {
    let html =
      file.html |> mellie.get_child_by_tag("main") |> option.from_result
    rss.RSSItem(fm.title, fm.path, fm.description, fm.date, html)
  })
}

pub fn main() {
  let cmd =
    clip.command({
      // to be used for running axe linting once pages are rendered
      use _report <- clip.parameter

      pipeline() |> charge.run()
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
