import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type File {
  File(path: String, relative: String, content: String)
}

pub type Path {
  Path(path: String, relative: String)
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
  |> result.replace_error("Error deleting dir " <> path)
}

pub fn copy_dir(at at: String, to to: String) -> Result(Nil, String) {
  simplifile.copy_directory(at:, to:)
  |> result.replace_error("Error copying dir " <> at <> " to " <> to)
}

pub fn read_file(path: String, rel: String) -> Result(File, String) {
  use content <- result.map(
    simplifile.read(path)
    |> result.replace_error("error reading file: " <> path),
  )
  let relative = string.drop_start(path, string.length(rel) + 1)

  File(content:, relative:, path:)
}

pub fn ls_dir(at: String) -> Result(List(Path), String) {
  use names <- result.try(
    simplifile.read_directory(at)
    |> result.replace_error("Error reading dir " <> at),
  )

  let paths =
    names
    |> list.map(fn(p) { Path(join([at, p]), p) })

  Ok(paths)
}

pub fn load_content(at: String) -> Result(List(File), String) {
  use paths <- result.map(read_dir_rec(at))
  use path <- list.filter_map(paths)

  read_file(path, at)
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

pub fn split(path: String) -> List(String) {
  string.split(path, "/")
}

pub fn is_child(file: File, dir: String) -> Bool {
  file.path |> string.starts_with(dir <> "/")
}

pub fn parent(path: String) -> String {
  let parts = path |> split
  parts |> list.take(list.length(parts) - 1) |> join
}

pub fn replace(full full, rel rel) {
  string.replace(full, rel, "")
}

pub fn ext(path: String) -> String {
  path
  |> string.split("/")
  |> list.last
  |> result.map(string.split(_, on: "."))
  |> result.try(list.last)
  |> result.unwrap("")
}

pub fn ensure_dir_exists(path: String) {
  use is_dir <- result.try(
    simplifile.is_directory(path)
    |> result.replace_error("Error checking if directory exists" <> path),
  )

  case is_dir {
    True -> Ok(Nil)
    False ->
      simplifile.create_directory_all(path)
      |> result.replace_error("Error creating directory " <> path)
  }
}
