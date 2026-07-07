import consts
import content/fs
import gleam/int
import gleam/javascript/promise.{type Promise}
import util

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
pub fn meta(_input_file: String) -> Promise(Result(Metadata, String)) {
  panic as "not supported for the given target"
}

pub fn optimize_image(
  in_path in_path: String,
  out_path out_path: String,
) -> Promise(Result(Nil, String)) {
  use out_dir <- util.try_resolve(fs.parent(out_path))

  use _ <- util.try_resolve(fs.ensure_dir_exists(out_dir))

  generate(in_path, out_path, consts.img_size)
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
