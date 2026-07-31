import consts
import gleam/int
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/result
import gleam/string
import shoki/async
import shoki/error
import shoki/internal/fs

@external(javascript, "./sharp_ffi.mjs", "generate")
fn generate(
  _input_file: String,
  _output_file: String,
  _size: Int,
) -> Promise(Result(Nil, String)) {
  panic as "not supported for the given target"
}

pub type Metadata {
  Metadata(width: Int, height: Int)
}

@external(javascript, "./sharp_ffi.mjs", "meta")
fn meta_(_input_file: String) -> Promise(Result(Metadata, String)) {
  panic as "not supported for the given target"
}

pub fn meta(input_file: fs.Path) -> Promise(error.ShokiResult(Metadata)) {
  meta_(input_file |> fs.to_abs_string)
  |> promise.map(result.map_error(_, error.ErrorReadingImageMeta))
}

pub fn optimize_image(
  in_path in_path: fs.Path,
  out_path out_path: fs.Path,
) -> Promise(error.ShokiResult(Nil)) {
  use out_dir <- async.try_resolve(fs.parent(out_path))

  use _ <- async.try_resolve(fs.ensure_dir(out_dir))

  generate(
    in_path |> fs.to_abs_string,
    out_path |> fs.to_abs_string,
    consts.img_size,
  )
  |> promise.map(result.replace_error(_, error.DateParseError("")))
}

pub fn aspect_ratio(meta: Metadata) -> Float {
  int.to_float(meta.width) /. int.to_float(meta.height)
}

pub type Orientation {
  Vertical
  Horizontal
}

pub fn orientation(meta: Metadata) {
  case aspect_ratio(meta) {
    m if m >. 1.0 -> Horizontal
    _ -> Vertical
  }
}

pub fn can_optimize(in_path: String) {
  let normalized = in_path |> string.lowercase

  list.any([".png", ".jpg", ".jpeg"], string.ends_with(normalized, _))
}
