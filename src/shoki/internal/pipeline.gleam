import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import lustre/element
import shoki/internal/fs
import shoki/internal/md
import shoki/shoki.{type ShokiResult, ErrorReadingFrontmatter}
import yamleam

pub opaque type Loaded(page, aggregate) {
  Loaded(pages: List(page), aggregated: aggregate)
}

type Loader(page, aggregate) =
  fn() -> ShokiResult(Loaded(page, aggregate))

type Renderer(page, aggregate) =
  fn(List(page), aggregate) -> ShokiResult(List(Asset))

pub opaque type Asset {
  HTMLFile(path: fs.SitePath, html: element.Element(Nil))
  CopyDir(from: fs.Path, to: fs.SitePath)
}

/// load -> process -> persist
pub opaque type Pipeline(page, aggregate) {
  Pipeline(
    /// Loads all data in so that any non-render output
    /// can be shared with other pages and pipelines
    load: Loader(page, aggregate),
    /// Process a single page - receives aggregated data
    render: Renderer(page, aggregate),
  )
}

pub opaque type MarkdownFile(a) {
  MarkdownFile(
    path: fs.Path,
    site_path: fs.SitePath,
    frontmatter: a,
    content: String,
  )
}

fn read_markdown_file(
  dir: fs.Path,
  file: fs.Path,
  frontmatter_decoder,
) -> ShokiResult(MarkdownFile(a)) {
  use content <- result.try(fs.read_text_file(file))

  let lines = content |> string.trim |> string.split("\n")

  let not_end = fn(str) { !string.starts_with(str, "---") }
  let site_path = md_file_to_site_path(dir, file)
  let decode = frontmatter_decoder(site_path)

  case lines {
    ["---", ..rest] -> {
      let #(front, content) = list.split_while(rest, not_end)
      let fm = front |> string.join("\n")

      use frontmatter <- result.try(
        yamleam.parse(fm, decode)
        |> result.replace_error(
          ErrorReadingFrontmatter(fm)
          |> shoki.error_context(file |> fs.path_to_string),
        ),
      )

      Ok(MarkdownFile(
        file,
        site_path,
        frontmatter,
        content |> list.drop(1) |> string.join("\n"),
      ))
    }
    _ -> Error(ErrorReadingFrontmatter("No frontmatter present"))
  }
}

fn read_markdown_files(dir: fs.Path, decode_frontmatter) {
  use files <- result.try(fs.ls_dir(dir))

  files
  |> list.filter(fs.has_ext(_, [fs.MD, fs.MDX]))
  |> list.map(read_markdown_file(dir, _, decode_frontmatter))
  |> shoki.collate_errors
}

pub fn from_markdown(dir dir: fs.Path, decode decode, agg agg, render render) {
  Pipeline(
    load: fn() {
      use pages <- result.map(read_markdown_files(dir, decode))

      Loaded(pages, pages |> list.map(frontmatter) |> agg)
    },
    render: fn(pages, agg) {
      pages
      |> list.map(fn(page) {
        render(page, agg) |> result.map(to_html_file(page, _))
      })
      |> shoki.collate_errors
    },
  )
}

pub fn merge(
  prev: Pipeline(page, aggregate),
  to_pages: fn(aggregate) -> List(page),
  render: Renderer(page, aggregate),
) {
  Pipeline(
    load: fn() {
      use prev <- result.map(prev.load())
      let next = prev.aggregated |> to_pages

      Loaded(next, prev)
    },
    render: fn(pages, prev_loaded) {
      use prev_result <- result.try(prev.render(
        prev_loaded.pages,
        prev_loaded.aggregated,
      ))

      use next_result <- result.try(render(pages, prev_loaded.aggregated))

      list.append(prev_result, next_result) |> Ok
    },
  )
}

pub fn with(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(List(Asset)),
) {
  Pipeline(load: from.load, render: fn(pages, aggregated) {
    use prev_result <- result.try(from.render(pages, aggregated))
    use next_result <- result.try(render(aggregated))

    list.append(prev_result, next_result) |> Ok
  })
}

pub fn static_dir(from: fs.Path) {
  fn(_) {
    use to <- result.map(fs.site_path_from_string("/"))
    CopyDir(from, to) |> list.wrap
  }
}

pub fn run(pipeline: Pipeline(page, aggregate)) {
  use loaded <- result.try(pipeline.load())
  pipeline.render(loaded.pages, loaded.aggregated)
}

fn write_one(out_dir: fs.Path, output: Asset) {
  case output {
    HTMLFile(path:, html:) ->
      fs.write_site_file(out_dir, path, html |> element.to_document_string)
    CopyDir(from:, to:) -> fs.copy_site_dir(out_dir, from, to)
  }
}

pub fn write_all(out_dir: fs.Path, outputs: List(Asset)) {
  use _ <- result.try(fs.delete_dir(out_dir))
  outputs
  |> list.map(write_one(out_dir, _))
  |> shoki.collate_errors
  |> result.replace(Nil)
}

pub fn frontmatter(file: MarkdownFile(a)) {
  file.frontmatter
}

fn markdown_ext_replacements() {
  dict.new()
  |> dict.insert(fs.MD, fs.HTML)
}

fn md_file_to_site_path(base: fs.Path, file: fs.Path) {
  fs.to_site_path(base, file, markdown_ext_replacements())
}

pub fn to_html_file(file: MarkdownFile(a), rendered: element.Element(Nil)) {
  HTMLFile(file.site_path, rendered)
}

pub fn create_html_file(path: fs.SitePath, rendered: element.Element(Nil)) {
  HTMLFile(path, rendered)
}

pub fn render_markdown(file: MarkdownFile(a)) {
  file.content |> md.parse
}

pub fn sort_assets(assets: List(Asset)) {
  assets
  |> list.sort(fn(a, b) {
    string.compare(
      a |> asset_path |> fs.site_path_to_string,
      b |> asset_path |> fs.site_path_to_string,
    )
  })
}

fn asset_path(asset: Asset) {
  case asset {
    HTMLFile(path:, html: _) -> path
    CopyDir(from: _, to:) -> to
  }
}

pub fn asset_to_readable_string(asset: Asset) {
  case asset {
    HTMLFile(path:, html:) ->
      "HTMLFile: "
      <> path |> fs.site_path_to_string
      <> "\n"
      <> html |> element.to_readable_string
    CopyDir(from, to) ->
      "CopyDir: \n  from: "
      <> from |> fs.path_to_string
      <> "\n  to: "
      <> to |> fs.site_path_to_string
  }
}
