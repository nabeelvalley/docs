import gleam/dict
import gleam/float
import gleam/io
import gleam/javascript/promise
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result
import gleam/uri
import mellie
import mellie/attr
import shoki
import shoki/async
import shoki/error
import shoki/internal/fs
import shoki/internal/sharp

fn optimized_images_path() {
  let assert Ok(path) = fs.site_path_from_string("/optimized-images")

  path
}

pub fn with_image_optimization(pipeline, static_images_dir: fs.Path) {
  pipeline
  |> shoki.with_task(image_optimize_task(static_images_dir))
}

pub fn image_optimize_task(static_images_dir) {
  let optimized_dir = optimized_images_path()
  fn(asset: shoki.Asset) -> Result(List(shoki.Task), error.ShokiErr) {
    {
      use file <- shoki.if_html(asset, Ok([]))
      use img <- list.try_map(mellie.get_children_by_tag(file.html, "img"))

      echo img |> mellie.element_to_string

      case mellie.attr(img, "src") {
        Error(_) -> Ok([])
        Ok(src) -> {
          // If we can't optimize an image then we just skip it
          let resolved =
            result.unwrap(
              resolve(static_images_dir, file.source, src) |> echo,
              None,
            )
          {
            use input_path <- option.map(resolved)
            case can_optimize(input_path) {
              False -> []
              True -> {
                let output = get_output_path(optimized_dir, input_path)

                let update_task =
                  shoki.html_file_transform_task(file.path, img, fn() {
                    render_image(img, input_path, output)
                  })
                let generate_task = optimize_image_task(input_path, output)

                [update_task, generate_task]
              }
            }
          }
          |> option.unwrap([])
          |> Ok
        }
      }
    }
    |> result.map(list.flatten)
  }
}

fn can_optimize(input_path: fs.Path) -> Bool {
  fs.has_ext(input_path, optimized_exts())
}

fn optimize_image_task(input_path, site_path) {
  shoki.task(fn(state) {
    use output_path <- async.try_resolve(fs.site_path_to_path(
      state.out_dir,
      site_path,
    ))

    io.println("optimize: " <> input_path |> fs.path_to_string)
    sharp.optimize_image(input_path, output_path)
    |> promise.map_try(fn(_) { Ok([site_path]) })
  })
}

fn from_uri_path(src) {
  uri.percent_decode(src)
  |> result.replace_error(error.InvalidImageSrc(src))
}

/// Resolves a file path if it exists
fn resolve(static_dir: fs.Path, source: Option(fs.Path), src: String) {
  case src {
    "https://" <> _ | "http://" <> _ -> Ok(None)

    // relative to static dir
    "/" <> src -> {
      from_uri_path(src)
      |> result.try(fs.resolve(static_dir, _))
      |> result.map(fn(p) {
        case fs.is_file(p) {
          True -> Some(p)
          False -> None
        }
      })
    }

    // otherwise must be relative to source file
    _ ->
      case source {
        None -> Error(error.ImageNotFound(src))
        Some(file) -> {
          let src =
            from_uri_path(src)
            |> result.unwrap(src)

          let dir = fs.parent(file)

          dir
          |> result.try(fs.resolve(_, src))
          |> result.map(fn(p) {
            case fs.is_file(p) {
              True -> Some(p)
              False -> None
            }
          })
        }
      }
  }
}

fn optimized_exts() {
  [fs.JPG, fs.JPEG, fs.PNG]
}

fn optimized_ext_mapping() {
  optimized_exts()
  |> list.map(pair.new(_, fs.WEBP))
  |> dict.from_list
}

fn get_output_path(optimized_images_path: fs.SitePath, input: fs.Path) {
  fs.to_site_path(fs.cwd(), input, optimized_ext_mapping())
  |> fs.concat_site_path(optimized_images_path, _)
}

fn render_image(img, input: fs.Path, output: fs.SitePath) {
  use meta <- promise.try_await(sharp.meta(input))

  let aspect_ratio =
    meta
    |> sharp.aspect_ratio
    |> float.to_string
    |> mellie.attribute("aspect-ratio", _)

  let orientation =
    case sharp.orientation(meta) {
      sharp.Vertical -> "vertical"
      sharp.Horizontal -> "horizontal"
    }
    |> mellie.attribute("orientation", _)

  let alt = mellie.attr(img, "img") |> option.from_result

  let src = attr.src(output |> fs.site_path_to_string)
  let alt =
    attr.alt(
      alt
      |> option.unwrap(fs.file_name_only(input)),
    )

  let result =
    img
    |> mellie.set_attributes([src, alt, aspect_ratio, orientation])

  result |> Ok |> promise.resolve
}
