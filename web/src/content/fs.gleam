import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type File {
  File(path: String, relative: String, content: String)
}

fn read_dir_rec(at: String) -> Result(List(String), String) {
  use is_dir <- result.try(
    simplifile.is_directory(at)
    |> result.replace_error("Could not read path: " <> at),
  )

  case is_dir {
    False -> Ok([at])
    True -> {
      use paths <- result.try(
        simplifile.read_directory(at)
        |> result.replace_error("Could not read dir: " <> at),
      )

      paths
      |> list.try_map(fn(p) { read_dir_rec(join([at, p])) })
      |> result.map(list.flatten)
    }
  }
}

pub fn write(path: String, content: String) -> Result(Nil, String) {
  let dir = parent(path)

  use _ <- result.try(
    simplifile.create_directory_all(dir)
    |> result.replace_error("Failed to create dir: " <> dir),
  )

  simplifile.write(path, content)
  |> result.replace_error("Failed to write file: " <> path)
}

pub fn delete(path: String) -> Result(Nil, String) {
  simplifile.delete_all([path])
  |> result.replace_error("Error deleting out dir")
}

pub fn load_content(at: String) -> Result(List(File), String) {
  use paths <- result.map(read_dir_rec(at))
  use path <- list.filter_map(paths)
  use content <- result.map(simplifile.read(path))

  let relative = string.drop_start(path, string.length(at) + 1)

  File(content:, relative:, path:)
}

fn has_ext(file: File, ext: String) -> Bool {
  file.path |> string.ends_with(ext)
}

pub fn is_markdown(file: File) -> Bool {
  has_ext(file, ".md") || has_ext(file, ".mdx")
}

pub fn is_json(file: File) -> Bool {
  has_ext(file, ".json")
}

pub fn join(parts: List(String)) -> String {
  string.join(parts, with: "/")
}

pub fn split(str: String) -> List(String) {
  string.split(str, "/")
}

pub fn is_child(file: File, dir: String) -> Bool {
  file.path |> string.starts_with(dir <> "/")
}

pub fn parent(path: String) -> String {
  let parts = path |> split
  parts |> list.take(list.length(parts) - 1) |> join
}
