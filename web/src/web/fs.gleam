import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type File {
  File(path: String, content: String)
}

fn read_dir_rec(at: String) {
  simplifile.read_directory(at)
  |> result.try(
    list.try_map(_, fn(i: String) {
      let inner = join([at, i])
      simplifile.is_directory(inner)
      |> result.try(fn(is_dir) {
        case is_dir {
          True -> {
            read_dir_rec(inner)
          }
          False -> Ok([inner])
        }
      })
    }),
  )
  |> result.map(list.flatten)
}

pub fn load_content(at: String) {
  result.map(read_dir_rec(at), fn(paths) {
    list.filter_map(paths, fn(path) {
      simplifile.read(path)
      |> result.map(File(content: _, path: path))
    })
  })
}

fn has_ext(file: File, ext: String) {
  file.path |> string.ends_with(ext)
}

pub fn is_markdown(file: File) {
  has_ext(file, ".md") || has_ext(file, ".mdx")
}

pub fn is_json(file: File) {
  has_ext(file, ".json")
}

pub fn join(parts: List(String)) {
  string.join(parts, with: "/")
}

pub fn is_child(file: File, dir: String) {
  file.path |> string.starts_with(dir <> "/")
}
