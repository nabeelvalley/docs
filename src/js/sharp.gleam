import consts
import content/fs
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

pub fn optimize_image(
  in_path in_path: String,
  out_path out_path: String,
) -> Promise(Result(Nil, String)) {
  use out_dir <- util.try_resolve(fs.parent(out_path))

  use _ <- util.try_resolve(fs.ensure_dir_exists(out_dir))

  generate(in_path, out_path, consts.img_size)
}
