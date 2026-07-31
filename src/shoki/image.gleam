import gleam/dict
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/uri
import mellie
import mellie/attr
import shoki
import shoki/component
import shoki/error
import shoki/internal/fs

const src_data_key = "shoki-original-path"

fn create_image_optimization_placeholder(el) {
  let src = el |> mellie.attrs |> dict.from_list |> dict.get("src")

  case src {
    Error(_) -> el
    Ok(src) -> {
      el |> mellie.set_attribute(attr.data(src_data_key, src))
    }
  }
}

pub fn with_image_optimization(pipeline, static_images_dir) {
  pipeline
  |> shoki.with_components([
    component.new("img", fn(_, el) { create_image_optimization_placeholder(el) }),
  ])
  |> shoki.with_task(fn(asset) {
    {
      use file <- shoki.if_html(asset, Ok([]))
      list.try_map(mellie.get_children_by_tag(file.html, "img"), fn(img) {
        case mellie.data_attr(img, src_data_key) {
          Error(_) -> Ok([])
          Ok(src) ->
            case resolve(static_images_dir, file.source, src) {
              Error(err) -> Error(err)
              Ok(None) -> Ok([])
              Ok(Some(resolved)) -> {
                let update_task =
                  shoki.html_file_transform_task(file.path, img, todo)
                let generate_task = shoki.task(todo)

                Ok([update_task, generate_task])
              }
            }
        }
      })
    }
    |> result.map(list.flatten)
  })
}

fn from_uri_path(src) {
  uri.percent_decode(src)
  |> result.replace_error(error.InvalidImageSrc(src))
}

fn resolve(static_dir: fs.Path, source: Option(fs.Path), src: String) {
  case src {
    "https://" <> _ | "http://" <> _ -> Ok(None)

    // relative to static dir
    "/" <> src -> {
      from_uri_path(src)
      |> result.try(fs.resolve(static_dir, _))
      |> result.map(Some)
    }

    // otherwise must be relative to source file
    _ ->
      case source {
        None -> Error(error.ImageNotFound(src))
        Some(source) ->
          from_uri_path(src)
          |> result.try(fs.resolve(source, _))
          |> result.map(Some)
      }
  }
}
