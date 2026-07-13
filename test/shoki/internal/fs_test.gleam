import birdie
import gleam/list
import gleam/string
import shoki/internal/fs

pub fn ls_dir_test() {
  let assert Ok(dir) = fs.from_relative_dir("./test/workspace")
  let assert Ok(files) = fs.ls_dir(dir)

  let str = files |> list.map(fs.file_path_to_string) |> string.join("\n")

  str
  |> birdie.snap("shok ls_dir")
}
