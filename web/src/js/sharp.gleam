import content/fs
import gleam/javascript/promise.{type Promise}
import gleam/result

@external(javascript, "./sharp_ffi.mjs", "generate")
fn generate(
  _input_file: String,
  _output_dir: String,
  _width: Int,
  _done: fn(Result(String, String)) -> Nil,
) -> Promise(Nil) {
  panic as "not supported for the given target"
}

pub fn resize_image(
  path path: String,
  out_dir out_dir: String,
  width width: Int,
  cb cb: fn(Result(String, String)) -> Nil,
) {
  use _ <- result.map(fs.ensure_dir_exists(out_dir))
  use path <- generate(path, out_dir, width)

  cb(path)
}
