import gleam/list
import gleam/option
import gleam/result
import gleam/string
import mellie
import shoki/component
import shoki/internal/fs
import shoki/shoki.{type ShokiResult}

pub opaque type Loaded(page, aggregate) {
  Loaded(pages: List(page), aggregated: aggregate)
}

type Loader(state, aggregate) =
  fn() -> ShokiResult(Loaded(state, aggregate))

type Renderer(state, aggregate) =
  fn(List(state), aggregate) -> ShokiResult(List(Asset))

pub type Asset {
  HTMLFile(
    source: option.Option(fs.Path),
    path: fs.SitePath,
    html: mellie.ElementTree,
  )
  CopyDir(from: fs.Path, to: fs.SitePath)
}

/// load -> process -> persist
pub opaque type Pipeline(state, aggregate) {
  Pipeline(
    /// Loads all data in so that any non-render output
    /// can be shared with other pages and pipelines
    load: Loader(state, aggregate),
    /// Process a single page - receives aggregated data
    render: Renderer(state, aggregate),
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

pub fn with_one(from, render) {
  use agg <- with(from)

  agg |> render |> result.map(list.wrap)
}

pub fn with_static_dir(pipeline, dir: fs.Path) {
  with(pipeline, fn(_) {
    use to <- result.map(fs.site_path_from_string("/"))
    CopyDir(dir, to) |> list.wrap
  })
}

pub fn with_components(
  from: Pipeline(page, aggregate),
  comps: List(component.Component(List(Asset))),
) {
  Pipeline(load: from.load, render: fn(pages, aggregated) {
    use assets <- result.try(from.render(pages, aggregated))
    let rendered =
      assets
      |> list.map(fn(asset) {
        case asset {
          HTMLFile(source:, path:, html:) -> {
            let #(html, assets) = component.render(source, html, comps)
            [HTMLFile(source:, path:, html:), ..assets |> list.flatten]
          }
          _ -> [asset]
        }
      })

    rendered |> list.flatten |> Ok
  })
}

pub fn run(pipeline: Pipeline(page, aggregate)) {
  use loaded <- result.try(pipeline.load())
  pipeline.render(loaded.pages, loaded.aggregated)
}

fn write_one(out_dir: fs.Path, output: Asset) {
  case output {
    HTMLFile(source: _, path:, html:) ->
      fs.write_site_file(out_dir, path, html |> mellie.to_document_string)
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

pub fn html_file_without_source(
  path: fs.SitePath,
  rendered: mellie.ElementTree,
) {
  HTMLFile(option.None, path, rendered)
}

pub fn create_html_file(
  source: fs.Path,
  path: fs.SitePath,
  rendered: mellie.ElementTree,
) {
  HTMLFile(option.Some(source), path, rendered)
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
    HTMLFile(source: _, path:, html: _) -> path
    CopyDir(from: _, to:) -> to
  }
}

pub fn asset_to_readable_string(asset: Asset) {
  case asset {
    HTMLFile(source:, path:, html:) ->
      "HTMLFile: "
      <> source
      |> option.map(fs.path_to_string)
      |> option.unwrap("[no source]")
      <> ":"
      <> path |> fs.site_path_to_string
      <> "\n"
      <> html |> mellie.to_document_string
    CopyDir(from, to) ->
      "CopyDir: \n  from: "
      <> from |> fs.path_to_string
      <> "\n  to: "
      <> to |> fs.site_path_to_string
  }
}

pub fn find_asset(assets: List(Asset), path: fs.SitePath) {
  assets |> list.find(fn(a) { path == a |> asset_path })
}

pub fn assets_to_readable_string(assets: List(Asset)) {
  assets
  |> sort_assets
  |> list.map(asset_to_readable_string)
  |> string.join("\n\n")
}
