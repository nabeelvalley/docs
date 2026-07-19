import gleam/list
import gleam/result
import gleam/string
import lustre/element
import shoki/internal/fs
import shoki/shoki.{type ShokiResult}

pub opaque type Loaded(page, aggregate) {
  Loaded(pages: List(page), aggregated: aggregate)
}

type Loader(page, aggregate) =
  fn() -> ShokiResult(Loaded(page, aggregate))

type Renderer(page, aggregate) =
  fn(List(page), aggregate) -> ShokiResult(List(Asset))

pub type Asset {
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

pub fn new(load load, render render) {
  Pipeline(load, render)
}

pub fn loaded(pages pages, aggregate aggregate) {
  Loaded(pages, aggregate)
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

pub fn create_html_file(path: fs.SitePath, rendered: element.Element(Nil)) {
  HTMLFile(path, rendered)
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
