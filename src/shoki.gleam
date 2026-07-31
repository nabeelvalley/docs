import gleam/dict
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import mellie
import presentable_soup
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
  fn(List(state), aggregate) -> ShokiResult(Rendered)

pub opaque type Rendered {
  Rendered(assets: List(Asset), tasks: List(Task))
}

pub opaque type HTMLFileTransform {
  HTMLFileTransform(
    path: fs.SitePath,
    replacement: mellie.ElementTree,
    render: fn() -> Promise(ShokiResult(mellie.ElementTree)),
  )
}

pub type TaskInfo {
  TaskInfo(out_dir: fs.Path)
}

pub opaque type Task {
  HTMLFileTransformTask(HTMLFileTransform)
  /// Tasks receive some context and are expected to return a list of
  /// any files they might have written
  Task(fn(TaskInfo) -> Promise(ShokiResult(List(fs.SitePath))))
}

pub type HTMLFile {
  HTMLFile(
    source: option.Option(fs.Path),
    path: fs.SitePath,
    html: mellie.ElementTree,
  )
}

pub opaque type Asset {
  HTMLFileAsset(HTMLFile)
  CopyDirAsset(from: fs.Path, to: fs.SitePath)
  TaskResult(fs.SitePath)
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
  Pipeline(out_dir, load, render)
}

pub fn loaded(
  pages pages: List(page),
  aggregate aggregate: aggregate,
) -> Loaded(page, aggregate) {
  Loaded(pages, aggregate)
}

pub fn merge(
  prev: Pipeline(page, aggregate),
  to_pages: fn(aggregate) -> List(page),
  render: Renderer(page, aggregate),
) -> Pipeline(page, Loaded(page, aggregate)) {
  Pipeline(
    out_dir: prev.out_dir,
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

      use next_result <- result.map(render(pages, prev_loaded.aggregated))

      merge_rendered(prev_result, next_result)
    },
  )
}

/// The raw unit for composing rendering pipelines
pub fn with(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(Rendered),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_result <- result.try(from.render(pages, aggregated))
    use next_result <- result.map(render(aggregated))

    merge_rendered(prev_result, next_result)
  })
}

/// Derive some assets from the pipeline aggregate
pub fn with_assets(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(List(Asset)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev_result <- result.try(from.render(pages, aggregated))
    use next_result <- result.map(render(aggregated))

    merge_rendered(prev_result, next_result |> from_assets)
  })
}

/// Derive an asset from the pipeline aggregate
pub fn with_asset(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(Asset),
) -> Pipeline(page, aggregate) {
  use agg <- with(from)
  use out <- result.map(render(agg))

  out |> list.wrap |> from_assets
}

/// Add a static directory to be copied as part of the pipeline
pub fn with_static_dir(
  pipeline: Pipeline(page, aggregate),
  dir: fs.Path,
) -> Pipeline(page, aggregate) {
  use _ <- with(pipeline)
  use to <- result.map(fs.site_path_from_string("/"))

  CopyDirAsset(dir, to) |> list.wrap |> from_assets
}

/// Add server-side components to the pipeline
pub fn with_components(
  from: Pipeline(page, aggregate),
  comps: List(component.Component(mellie.ElementTree)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev <- result.try(from.render(pages, aggregated))

    let Rendered(assets: prev_assets, tasks: prev_tasks) = prev

    let rendered =
      prev_assets
      |> list.map(fn(a) {
        use file <- if_html(a, a)

        let html = component.render(file.source, file.path, file.html, comps)

        HTMLFile(..file, html:)
        |> HTMLFileAsset
      })

    rendered
    |> Rendered(tasks: prev_tasks, assets: _)
    |> Ok
  })
}

/// Add assets that are derived from an existing asset, e.g. copying images that are needed for a given page
pub fn with_derived_assets(
  from: Pipeline(page, aggregate),
  extract: fn(Asset) -> ShokiResult(List(Asset)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev <- result.try(from.render(pages, aggregated))

    let results = prev.assets |> list.map(extract) |> error.collate_errors
    use result <- result.map(results)

    merge_rendered(prev, result |> list.flatten |> from_assets)
  })
}

/// Add some generic tasks into the pipeline for each asset, e.g. running an accessibility check on all generated html
pub fn with_task(
  from: Pipeline(page, aggregate),
  create_tasks: fn(Asset) -> ShokiResult(List(Task)),
) -> Pipeline(page, aggregate) {
  Pipeline(..from, load: from.load, render: fn(pages, aggregated) {
    use prev <- result.try(from.render(pages, aggregated))

    let results = prev.assets |> list.map(create_tasks) |> error.collate_errors

    use result <- result.map(results)

    merge_rendered(prev, result |> list.flatten |> from_tasks)
  })
}

/// Cleans the output directory and runs the pipeline
pub fn run(
  pipeline: Pipeline(page, aggregate),
) -> Promise(Result(List(Asset), error.ShokiErr)) {
  use _ <- async.try_resolve(fs.delete_dir(pipeline.out_dir))

  use loaded <- async.try_resolve(pipeline.load())

  use Rendered(assets:, tasks:) <- async.try_resolve(pipeline.render(
    loaded.pages,
    loaded.aggregated,
  ))

  let transform_tasks =
    tasks |> filter_html_transforms |> list.group(fn(p) { p.path })

  let asset_results =
    assets
    |> list.map(fn(a) {
      case a {
        HTMLFileAsset(file) -> {
          let appliccable =
            transform_tasks |> dict.get(file.path) |> result.unwrap([])
          use result <- promise.try_await(apply_tasks(file.html, appliccable))

          HTMLFile(..file, html: result)
          |> HTMLFileAsset
          |> list.wrap
          |> Ok
          |> promise.resolve
        }
        _ -> a |> list.wrap |> Ok |> promise.resolve
      }
    })

  let info = TaskInfo(pipeline.out_dir)
  let task_results =
    tasks
    |> filter_tasks
    |> list.map(fn(t) {
      t(info) |> promise.map_try(fn(r) { r |> list.map(TaskResult) |> Ok })
    })

  [asset_results, task_results]
  |> list.flatten
  |> promise.await_list
  |> promise.map(error.collate_errors)
  |> promise.map(result.map(_, list.flatten))
}

fn write_one(out_dir: fs.Path, output: Asset) -> Result(Nil, error.ShokiErr) {
  case output {
    HTMLFileAsset(file) ->
      fs.write_site_file(
        out_dir,
        file.path,
        file.html |> mellie.to_document_string,
      )
    CopyDirAsset(from:, to:) -> fs.copy_site_dir(out_dir, from, to)
    _ -> Ok(Nil)
  }
}

/// Write all resulting assets from the pipeline to disc
pub fn write_all(
  pipeline: Pipeline(a, b),
  assets: List(Asset),
) -> Result(Nil, error.ShokiErr) {
  // handle async asset rendering before comitting file
  assets
  |> list.map(write_one(pipeline.out_dir, _))
  |> error.collate_errors
  |> result.replace(Nil)
}

pub fn generated_html_file(
  path: fs.SitePath,
  rendered: mellie.ElementTree,
) -> Asset {
  HTMLFile(None, path, rendered) |> HTMLFileAsset
}

pub fn derived_html_file(
  source: fs.Path,
  path: fs.SitePath,
  rendered: mellie.ElementTree,
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
      <> file.html |> mellie.to_document_string
    CopyDirAsset(from, to) ->
      "CopyDir: \n  from: "
      <> from |> fs.path_to_string
      <> "\n  to: "
      <> to |> fs.site_path_to_string
    TaskResult(path) -> "Task Result: " <> path |> fs.site_path_to_string
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

type ElementReplacement {
  ElementReplacement(replace: mellie.ElementTree, with: mellie.ElementTree)
}

fn to_element_update_dict(
  updates: List(ElementReplacement),
) -> dict.Dict(presentable_soup.ElementTree, presentable_soup.ElementTree) {
  updates |> list.map(fn(u) { #(u.replace, u.with) }) |> dict.from_list
}

fn apply_element_updates(
  from in: mellie.ElementTree,
  with replacements: dict.Dict(mellie.ElementTree, mellie.ElementTree),
) {
  case dict.get(replacements, in) {
    Error(_) ->
      case in {
        presentable_soup.TextNode(_) -> in
        presentable_soup.ElementNode(tag: _, attributes: _, children:) ->
          presentable_soup.ElementNode(
            ..in,
            children: children
              |> list.map(apply_element_updates(_, replacements)),
          )
      }
    Ok(update) -> update
  }
}

fn apply_tasks(base, transforms: List(HTMLFileTransform)) {
  let processed =
    promise.await_list({
      use p <- list.map(transforms)
      use r <- promise.map_try(p.render())

      ElementReplacement(p.replacement, r) |> Ok
    })
    |> promise.map(error.collate_errors)

  use results <- promise.try_await(processed)

  apply_element_updates(base, results |> to_element_update_dict)
  |> Ok
  |> promise.resolve
}

fn merge_rendered(a: Rendered, b: Rendered) -> Rendered {
  Rendered(
    assets: list.append(a.assets, b.assets),
    tasks: list.append(a.tasks, b.tasks),
  )
}

pub fn from_assets(a) {
  Rendered(a, [])
}

pub fn from_tasks(a) {
  Rendered([], a)
}

pub fn html_file_transform_task(path, replace, render) {
  HTMLFileTransform(path, replace, render) |> HTMLFileTransformTask
}

fn filter_html_transforms(tasks: List(Task)) {
  list.map(tasks, fn(t) {
    case t {
      HTMLFileTransformTask(t) -> Some(t)
      _ -> None
    }
  })
  |> option.values
}

fn filter_tasks(tasks: List(Task)) {
  list.map(tasks, fn(t) {
    case t {
      Task(t) -> Some(t)
      _ -> None
    }
  })
  |> option.values
}

pub fn task(t) {
  Task(t)
}

pub fn if_html(asset: Asset, or_else, f) {
  case asset {
    HTMLFileAsset(file) -> f(file)
    _ -> or_else
  }
}
