import birdie
import gleam/list
import gleam/string
import shoki/internal/fs
import shoki/preset/default

pub fn ls_dir_test() {
  let assert Ok(dir) = fs.from_relative_dir("./test/workspace")
  let assert Ok(files) = fs.ls_dir(dir)

  let str =
    files
    |> list.map(fs.file_path_to_string)
    |> list.sort(string.compare)
    |> string.join("\n")

  str
  |> birdie.snap("internal ls_dir")
}

pub fn default_pipeline_test() {
  let assert Ok(dir) = fs.from_relative_dir("./test/workspace")

  let default_pipeline = default.create_pipeline(dir)
}
