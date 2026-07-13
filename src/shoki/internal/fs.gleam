import gleam/list
import gleam/result
import gleam/string
import shoki/shoki.{
  type ShokiResult, DirNotFound, ErrorReadingTextFile, FileNotFound,
  PathUnresolvable,
}
import simplifile

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
    |> result.replace_error(PathUnresolvable(joint)),
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
    |> result.replace_error(PathUnresolvable(joint)),
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

pub fn ls_dir(at: DirPath) -> ShokiResult(List(FilePath)) {
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

/// Converts a path to string within the current working directory.
/// This should only be used for printing data and not for working
/// with paths
pub fn file_path_to_string(p: FilePath) {
  let cwd = cwd().dir.path <> "/"

  p.file.path |> string.remove_prefix(matching: cwd)
}

pub fn read_text_file(p: FilePath) {
  simplifile.read(p.file.path)
  |> result.replace_error(ErrorReadingTextFile(p.file.path))
}

pub type Extension {
  MD
  MDX
}

fn to_suffix(ext: Extension) {
  case ext {
    MD -> ".md"
    MDX -> ".mdx"
  }
}

pub fn has_ext(file: FilePath, exts: List(Extension)) {
  let suffixes = exts |> list.map(to_suffix)

  list.any(suffixes, string.ends_with(file.file.path, _))
}
