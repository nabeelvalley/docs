import argv
import charge
import charge/error
import charge/footnote
import charge/fs
import charge/highlight
import charge/image
import charge/rss
import clip
import clip/flag
import consts
import content/metadata
import gleam/io
import gleam/javascript/promise
import gleam/list
import gleam/option
import gleam/result
import gleave
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

import charge/markdown

pub fn pipeline() {
  let assert Ok(out) = fs.from_cwd(consts.out_dir)
  let assert Ok(public) = fs.from_cwd(consts.public_dir)
  let assert Ok(md) = fs.from_cwd(consts.content_dir)

  markdown.from_markdown(
    out: out,
    dir: md,
    decode: metadata.decoder,
    agg: list.filter(_, metadata.is_published),
    render: fn(file, _metadatas) {
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
  |> footnote.with_footnotes
  |> charge.with_asset(index.render)
  |> charge.with_asset(blog.render)
  |> charge.with_asset(photography.render)
  |> charge.with_asset(docs.render)
  |> charge.with_asset(talks.render)
  |> charge.switch(fn(fm) {
    metadata.load_photos() |> result.map(metadata.SiteData(fm, _))
  })
  |> charge.with_assets(fn(data) {
    data.photos
    |> list.map(photography.render_photo_page)
    |> Ok
  })
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

fn to_rss_item(data: metadata.SiteData, file: charge.HTMLFile) {
  let found = data.frontmatters |> list.find(fn(i) { i.path == file.path })

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
      use dev <- clip.parameter
      use _report <- clip.parameter

      let run = case dev {
        False -> charge.run
        True -> charge.run_dev
      }

      pipeline() |> run
    })
    |> clip.flag(flag.new("dev"))
    |> clip.flag(
      flag.new("report") |> flag.help("run a11y and link-checking reports"),
    )

  let result = cmd |> clip.run(argv.load().arguments)

  case result {
    Error(err) -> {
      io.println_error(err)

      gleave.exit(1)
      |> promise.resolve
    }
    Ok(cmd_result) -> {
      use cmd_resolved <- promise.await(cmd_result)
      case cmd_resolved {
        Ok(_) -> io.println("Pipeline run successfully")
        Error(err) -> {
          io.println_error(err |> error.error_to_string)
          gleave.exit(1)
        }
      }
      |> promise.resolve
    }
  }
}
