import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import mellie
import mellie/element.{type ElementTree}
import shoki/async
import shoki/component
import shoki/error.{type ShokiResult}
import shoki/internal/fs

pub opaque type Loaded(page, aggregate) {
  Loaded(pages: List(page), aggregated: aggregate)
}

type Loader(state, aggregate) =
  fn() -> ShokiResult(Loaded(state, aggregate))

type Renderer(state, aggregate) =
  fn(List(state), aggregate) -> Promise(ShokiResult(Rendered))

pub type Rendered =
  List(Asset)

pub type HTMLFile {
  HTMLFile(source: Option(fs.Path), path: fs.SitePath, html: ElementTree)
}

pub opaque type Asset {
  HTMLFileAsset(HTMLFile)
  CopyDirAsset(from: fs.Path, to: fs.SitePath)
  TaskResult(fs.SitePath)
  TextFile(path: fs.SitePath, content: String)
}

/// load -> process -> persist
pub opaque type Pipeline(state, aggregate) {
  Pipeline(
    out_dir: fs.Path,
    /// Loads all data in so that any non-render output
    /// can be shared with other pages and pipelines
    load: Loader(state, aggregate),
    /// Process a single page - receives aggregated data
    render: Renderer(state, aggregate),
  )
}

pub fn new(
  out out_dir: fs.Path,
  load load: fn() -> Result(Loaded(state, aggregate), error.ShokiErr),
  render render: fn(List(state), aggregate) -> Result(Rendered, error.ShokiErr),
) -> Pipeline(state, aggregate) {
  Pipeline(out_dir, load, async.to_async2(render))
}

pub fn loaded(
  pages pages: List(page),
  aggregate aggregate: aggregate,
) -> Loaded(page, aggregate) {
  Loaded(pages, aggregate)
}

/// The raw unit for composing sync rendering pipelines
pub fn with_async(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> Promise(ShokiResult(Rendered)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_result <- promise.try_await(from.render(pages, aggregated))

    render(aggregated)
    |> promise.map(result.map(_, merge_rendered(prev_result, _)))
  })
}

pub fn with(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(Rendered),
) -> Pipeline(page, aggregate) {
  with_async(from, async.to_async1(render))
}

/// Derive some assets from the pipeline aggregate
pub fn with_assets(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(List(Asset)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_result <- promise.try_await(from.render(pages, aggregated))

    render(aggregated)
    |> result.map(merge_rendered(prev_result, _))
    |> promise.resolve
  })
}

/// Derive an asset from the pipeline aggregate
pub fn with_asset(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(Asset),
) -> Pipeline(page, aggregate) {
  use agg <- with(from)
  use out <- result.map(render(agg))

  out |> list.wrap
}

/// Add a static directory to be copied as part of the pipeline
pub fn with_static_dir(
  pipeline: Pipeline(page, aggregate),
  dir: fs.Path,
) -> Pipeline(page, aggregate) {
  use _ <- with(pipeline)
  use to <- result.map(fs.site_path_from_string("/"))

  CopyDirAsset(dir, to) |> list.wrap
}

/// Add server-side components to the pipeline
pub fn with_components(
  from: Pipeline(page, aggregate),
  comps: List(component.Component(ShokiResult(ElementTree))),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_assets <- promise.try_await(from.render(pages, aggregated))

    let rendered =
      prev_assets
      |> list.map(fn(a) {
        use file <- if_html(a, a |> Ok)

        component.render(file.source, file.path, from.out_dir, file.html, comps)
        |> result.map(fn(html) { HTMLFile(..file, html:) |> HTMLFileAsset })
      })

    rendered
    |> error.collate_errors
    |> promise.resolve
  })
}

pub fn with_async_component(from, comp) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_assets <- promise.try_await(from.render(pages, aggregated))

    prev_assets
    |> list.map(fn(a) {
      use file <- if_html(a, promise.resolve(Ok(a)))

      component.render_async(
        file.source,
        file.path,
        from.out_dir,
        file.html,
        comp,
      )
      |> promise.map_try(fn(html) {
        HTMLFile(..file, html: html)
        |> HTMLFileAsset
        |> Ok
      })
    })
    |> promise.await_list
    |> promise.map(error.collate_errors)
  })
}

/// Add assets that are derived from an existing asset, e.g. providing an alternate of each page
pub fn with_derived_assets(
  from: Pipeline(page, aggregate),
  extract: fn(Asset) -> ShokiResult(List(Asset)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_assets <- promise.try_await(from.render(pages, aggregated))

    let results =
      prev_assets
      |> list.map(extract)
      |> error.collate_errors
      |> result.map(list.flatten)

    result.map(results, fn(result) { merge_rendered(prev_assets, result) })
    |> promise.resolve
  })
}

/// Add some generic tasks into the pipeline given all the assets rendered till this point as well as the relevant aggregate
/// e.g. running creating an accessibility report on all generated html pages, creating an RSS Feed, etc.
pub fn with_summary(from, summarize) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_assets <- promise.try_await(from.render(pages, aggregated))

    summarize(prev_assets, aggregated)
    |> result.map(merge_rendered(prev_assets, _))
    |> promise.resolve
  })
}

/// Cleans the output directory and runs the pipeline
pub fn run(
  pipeline: Pipeline(page, aggregate),
) -> Promise(Result(List(Asset), error.ShokiErr)) {
  use _ <- async.try_resolve(
    fs.delete_dir_if_exists(pipeline.out_dir)
    |> fn(_) { Ok(Nil) },
  )

  use loaded <- async.try_resolve(pipeline.load())

  use assets <- promise.try_await(pipeline.render(
    loaded.pages,
    loaded.aggregated,
  ))

  write_all(pipeline.out_dir, assets)
  |> result.replace(assets)
  |> promise.resolve
}

fn write_one(out_dir: fs.Path, output: Asset) -> Result(Nil, error.ShokiErr) {
  case output {
    HTMLFileAsset(file) -> {
      fs.write_site_file(
        out_dir,
        file.path,
        file.html |> mellie.to_document_string,
      )
    }
    CopyDirAsset(from:, to:) -> fs.copy_site_dir(out_dir, from, to)
    TextFile(path, content) -> fs.write_site_file(out_dir, path, content)
    _ -> Ok(Nil)
  }
}

/// Write all resulting assets from the pipeline to disc
fn write_all(out_dir, assets: List(Asset)) -> Result(Nil, error.ShokiErr) {
  // handle async asset rendering before comitting file
  assets
  |> list.map(write_one(out_dir, _))
  |> error.collate_errors
  |> result.replace(Nil)
}

pub fn generated_html_file(path: fs.SitePath, rendered: ElementTree) -> Asset {
  HTMLFile(None, path, rendered) |> HTMLFileAsset
}

pub fn derived_html_file(
  source: fs.Path,
  path: fs.SitePath,
  rendered: ElementTree,
) -> Asset {
  HTMLFile(Some(source), path, rendered) |> HTMLFileAsset
}

pub fn sort_assets(assets: List(Asset)) -> List(Asset) {
  assets
  |> list.sort(fn(a, b) {
    string.compare(
      a |> asset_path |> fs.site_path_to_string,
      b |> asset_path |> fs.site_path_to_string,
    )
  })
}

fn asset_path(asset: Asset) -> fs.SitePath {
  case asset {
    HTMLFileAsset(file) -> file.path
    CopyDirAsset(from: _, to:) -> to
    TaskResult(path) -> path
    TextFile(path, _) -> path
  }
}

pub fn asset_to_readable_string(asset: Asset) -> String {
  case asset {
    HTMLFileAsset(file) ->
      "HTMLFile: "
      <> file.source
      |> option.map(fs.path_to_string)
      |> option.unwrap("[no source]")
      <> ":"
      <> file.path |> fs.site_path_to_string
      <> "\n"
      <> file.html |> mellie.element_to_string_pretty
    CopyDirAsset(from, to) ->
      "CopyDir: \n  from: "
      <> from |> fs.path_to_string
      <> "\n  to: "
      <> to |> fs.site_path_to_string
    TaskResult(path) -> "Task Result: " <> path |> fs.site_path_to_string
    TextFile(path, content) ->
      "Text File : " <> path |> fs.site_path_to_string <> ":\n" <> content
  }
}

pub fn find_asset(
  assets: List(Asset),
  path: fs.SitePath,
) -> Result(Asset, Nil) {
  assets |> list.find(fn(a) { path == a |> asset_path })
}

pub fn assets_to_readable_string(assets: List(Asset)) -> String {
  assets
  |> sort_assets
  |> list.map(asset_to_readable_string)
  |> string.join("\n\n")
}

fn merge_rendered(a: Rendered, b: Rendered) -> Rendered {
  list.append(a, b)
}

pub fn if_html(asset: Asset, or_else, f) {
  case asset {
    HTMLFileAsset(file) -> f(file)
    _ -> or_else
  }
}

pub fn text_file(path: fs.SitePath, content: String) {
  TextFile(path:, content:)
}
