import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type R(r) =
  Result(r, ShokiErr)

pub type ShokiErr {
  FileNotFound(String)
  DirNotFound(String)
  Unresolvable(String)
}

pub opaque type Path {
  Path(path: String)
}

type RelativePath {
  RelativePath(path: String)
}

pub opaque type FilePath {
  FilePath(file: Path)
}

pub opaque type DirPath {
  DirPath(dir: Path)
}

fn resolve_file(path: DirPath, relative: RelativePath) {
  let joint = path.dir.path <> "/" <> relative.path
  use resolved <- result.try(
    simplifile.resolve(joint)
    |> result.replace_error(Unresolvable(joint)),
  )

  use is_file <- result.try(
    simplifile.is_file(resolved) |> result.replace_error(FileNotFound(resolved)),
  )

  case is_file {
    True -> Ok(resolved |> Path |> FilePath)
    False -> Error(FileNotFound(resolved))
  }
}

fn resolve_dir(path: DirPath, relative: RelativePath) {
  let joint = path.dir.path <> "/" <> relative.path
  use resolved <- result.try(
    simplifile.resolve(joint)
    |> result.replace_error(Unresolvable(joint)),
  )

  use is_dir <- result.try(
    simplifile.is_directory(resolved)
    |> result.replace_error(DirNotFound(resolved)),
  )

  case is_dir {
    True -> Ok(resolved |> Path |> DirPath)
    False -> Error(DirNotFound(resolved))
  }
}

fn cwd() {
  // something would be very wrong if we couldn't resolve the current dir
  let assert Ok(cwd) = simplifile.resolve(".")

  cwd |> Path |> DirPath
}

pub fn from_relative_dir(rel: String) {
  resolve_dir(cwd(), rel |> RelativePath)
}

pub fn ls_dir(at: DirPath) -> R(List(FilePath)) {
  use paths <- result.try(
    simplifile.read_directory(at.dir.path)
    |> result.replace_error(DirNotFound(at.dir.path))
    |> result.map(list.map(_, RelativePath)),
  )

  let files = paths |> list.map(resolve_file(at, _)) |> result.values
  let dirs = paths |> list.map(resolve_dir(at, _)) |> result.values

  use subdirs <- result.try(dirs |> list.map(ls_dir) |> result.all)

  files
  |> list.append(subdirs |> list.flatten)
  |> Ok
}

pub fn file_path_to_string(p: FilePath) {
  let cwd = cwd().dir.path <> "/"

  p.file.path |> string.remove_prefix(matching: cwd)
}
