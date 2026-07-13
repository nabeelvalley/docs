import birdie
import gleam/list
import gleam/string
import shoki/shoki

pub fn ls_dir_test() {
  let assert Ok(dir) = shoki.from_relative_dir("./test/workspace")
  let assert Ok(files) = shoki.ls_dir(dir)

  let str = files |> list.map(shoki.file_path_to_string) |> string.join("\n")

  str
  |> birdie.snap("shok ls_dir")
}
