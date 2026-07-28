import gleam/dict
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import mellie
import presentable_soup
import shoki/component
import shoki/internal/fs
import shoki/shoki.{type ShokiResult}
import util

pub opaque type Loaded(page, aggregate) {
  Loaded(pages: List(page), aggregated: aggregate)
}

type Loader(state, aggregate) =
  fn() -> ShokiResult(Loaded(state, aggregate))

type Renderer(state, aggregate) =
  fn(List(state), aggregate) -> ShokiResult(Rendered)

pub opaque type Rendered {
  Rendered(assets: List(Asset), processors: List(Task))
}

pub opaque type Task {
  HTMLFileTransformTask(
    path: fs.SitePath,
    replacement: mellie.ElementTree,
    render: fn() -> Promise(ShokiResult(mellie.ElementTree)),
  )
  // Task(fn() -> Promise(ShokiResult(Nil)))
}

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

pub fn new(
  load load: fn() -> Result(Loaded(state, aggregate), shoki.ShokiErr),
  render render: fn(List(state), aggregate) -> Result(Rendered, shoki.ShokiErr),
) -> Pipeline(state, aggregate) {
  Pipeline(load, render)
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

      merge_rendered(prev_result, next_result) |> Ok
    },
  )
}

pub fn with(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(Rendered),
) -> Pipeline(page, aggregate) {
  Pipeline(load: from.load, render: fn(pages, aggregated) {
    use prev_result <- result.try(from.render(pages, aggregated))
    use next_result <- result.try(render(aggregated))

    merge_rendered(prev_result, next_result) |> Ok
  })
}

pub fn with_one(
  from: Pipeline(page, aggregate),
  render: fn(aggregate) -> ShokiResult(Rendered),
) -> Pipeline(page, aggregate) {
  use agg <- with(from)
  use out <- result.map(render(agg))

  out
}

pub fn with_static_dir(
  pipeline: Pipeline(page, aggregate),
  dir: fs.Path,
) -> Pipeline(page, aggregate) {
  use _ <- with(pipeline)
  use to <- result.map(fs.site_path_from_string("/"))

  CopyDir(dir, to) |> list.wrap |> assets
}

pub fn with_components(
  from: Pipeline(page, aggregate),
  comps: List(component.Component(mellie.ElementTree)),
) -> Pipeline(page, aggregate) {
  Pipeline(load: from.load, render: fn(pages, aggregated) {
    use prev <- result.map(from.render(pages, aggregated))

    let Rendered(assets: prev_assets, processors: prev_processors) = prev

    let rendered =
      prev_assets
      |> list.map(fn(a) {
        case a {
          HTMLFile(source:, path:, html:) -> {
            let html = component.render(html, comps)

            Rendered(
              processors: prev_processors,
              assets: HTMLFile(source:, path:, html:) |> list.wrap,
            )
          }
          _ -> prev
        }
      })

    rendered |> flatten_rendered
  })
}

pub fn with_additional_assets(
  from: Pipeline(page, aggregate),
  extract: fn(Asset) -> ShokiResult(List(Asset)),
) -> Pipeline(page, aggregate) {
  Pipeline(load: from.load, render: fn(pages, aggregated) {
    use prev <- result.try(from.render(pages, aggregated))

    let results = prev.assets |> list.map(extract) |> shoki.collate_errors

    use result <- result.map(results)

    merge_rendered(prev, result |> list.flatten |> assets)
  })
}

pub fn with_task(
  from: Pipeline(page, aggregate),
  create_tasks: fn(Asset) -> ShokiResult(List(Task)),
) -> Pipeline(page, aggregate) {
  Pipeline(load: from.load, render: fn(pages, aggregated) {
    use prev <- result.try(from.render(pages, aggregated))

    let results = prev.assets |> list.map(create_tasks) |> shoki.collate_errors

    use result <- result.map(results)

    merge_rendered(prev, result |> list.flatten |> processors)
  })
}

pub fn run(
  pipeline: Pipeline(page, aggregate),
) -> Promise(Result(List(Asset), shoki.ShokiErr)) {
  use loaded <- util.try_resolve(pipeline.load())

  use Rendered(assets:, processors:) <- util.try_resolve(pipeline.render(
    loaded.pages,
    loaded.aggregated,
  ))

  let processors = processors |> list.group(fn(p) { p.path })

  assets
  |> list.map(fn(a) {
    case a {
      HTMLFile(source:, path:, html:) -> {
        let appliccable = processors |> dict.get(path) |> result.unwrap([])
        use result <- promise.try_await(apply_processors(html, appliccable))

        HTMLFile(source:, path:, html: result) |> Ok |> promise.resolve
      }
      CopyDir(from: _, to: _) -> a |> Ok |> promise.resolve
    }
  })
  |> promise.await_list
  |> promise.map(shoki.collate_errors)
}

fn write_one(out_dir: fs.Path, output: Asset) -> Result(Nil, shoki.ShokiErr) {
  case output {
    HTMLFile(source: _, path:, html:) ->
      fs.write_site_file(out_dir, path, html |> mellie.to_document_string)
    CopyDir(from:, to:) -> fs.copy_site_dir(out_dir, from, to)
  }
}

pub fn write_all(
  out_dir: fs.Path,
  assets: List(Asset),
) -> Result(Nil, shoki.ShokiErr) {
  use _ <- result.try(fs.delete_dir(out_dir))
  // handle async asset rendering before comitting file
  assets
  |> list.map(write_one(out_dir, _))
  |> shoki.collate_errors
  |> result.replace(Nil)
}

pub fn html_file_without_source(
  path: fs.SitePath,
  rendered: mellie.ElementTree,
) -> Asset {
  HTMLFile(option.None, path, rendered)
}

pub fn create_html_file(
  source: fs.Path,
  path: fs.SitePath,
  rendered: mellie.ElementTree,
) -> Asset {
  HTMLFile(option.Some(source), path, rendered)
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
    HTMLFile(source: _, path:, html: _) -> path
    CopyDir(from: _, to:) -> to
  }
}

pub fn asset_to_readable_string(asset: Asset) -> String {
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

fn apply_processors(base, processors: List(Task)) {
  let processed =
    // this is gross, there must be a nicer way to do this
    promise.await_list(
      processors
      |> list.map(fn(p) {
        p.render()
        |> promise.map(fn(r) {
          r |> result.map(ElementReplacement(p.replacement, _))
        })
      }),
    )
    |> promise.map(shoki.collate_errors)

  use results <- promise.try_await(processed)
  apply_element_updates(base, results |> to_element_update_dict)
  |> Ok
  |> promise.resolve
}

pub fn merge_rendered(a: Rendered, b: Rendered) -> Rendered {
  Rendered(
    assets: list.append(a.assets, b.assets),
    processors: list.append(a.processors, b.processors),
  )
}

pub fn flatten_rendered(r: List(Rendered)) {
  list.fold(r, Rendered([], []), merge_rendered)
}

pub fn assets(a) {
  Rendered(a, [])
}

pub fn processors(a) {
  Rendered([], a)
}

pub fn html_file_transform_task(path, replace, render) {
  HTMLFileTransformTask(path, replace, render)
}
