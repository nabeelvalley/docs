import consts
import content/fs
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/regexp
import gleam/result

@external(javascript, "./sharp_ffi.mjs", "generate")
fn generate(
  _input_file: String,
  _output_file: String,
  _width: Int,
) -> Promise(Result(Nil, String)) {
  panic as "not supported for the given target"
}

pub fn optimize_image(path path: String) -> Promise(Result(String, String)) {
  use re <- promise.try_await(promise.resolve(
    regexp.from_string("[\\W_]+")
    |> result.replace_error("Error creating regexp for file name replacement"),
  ))

  let out_dir = fs.join([consts.out_dir, "optimized"])

  use _ <- promise.await(promise.resolve(fs.ensure_dir_exists(out_dir)))

  let out_name = regexp.replace(re, in: path, with: "_") <> ".webp"
  let out_path = fs.join([out_dir, out_name])

  generate(path, out_path, consts.default_img_width)
  |> promise.tap(fn(_) {
    io.println("Optimized image " <> path <> " to " <> out_path)
  })
  |> promise.map(result.replace(_, out_path))
}
