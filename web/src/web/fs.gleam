import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type File {
  File(path: String, content: String)
}

fn read_dir_rec(at: String) -> Result(List(String), simplifile.FileError) {
  result.try(simplifile.read_directory(at), fn(files_and_folders) {
    use path <- list.try_map(files_and_folders)

    let inner = join([at, path])
    use is_dir <- result.try(simplifile.is_directory(inner))

    let files = case is_dir {
      True -> {
        read_dir_rec(inner)
      }
      False -> Ok([inner])
    }
    files
  })
  |> result.map(list.flatten)
}

pub fn load_content(at: String) -> Result(List(File), simplifile.FileError) {
  use paths <- result.map(read_dir_rec(at))
  use path <- list.filter_map(paths)
  use content <- result.map(simplifile.read(path))

  File(content:, path:)
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

pub fn is_child(file: File, dir: String) -> Bool {
  file.path |> string.starts_with(dir <> "/")
}
