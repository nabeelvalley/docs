import gleam/dict
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import lustre/attribute
import shoki/shoki.{
  type ShokiResult, DirNotFound, ErrorCreatingDir, ErrorDeletingDir,
  ErrorReadingTextFile, ErrorWritingTextFile, FileNotFound, InvalidSitePath,
  PathUnresolvable,
}
import simplifile

pub opaque type Path {
  Path(path: String)
}

type RelativePath {
  RelativePath(path: String)
}

pub opaque type SitePath {
  SitePath(slug: String)
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

pub fn delete_dir(dir: DirPath) {
  let path = dir.dir.path
  simplifile.delete(path) |> result.replace_error(ErrorDeletingDir(path))
}

pub fn ensure_relative_dir(rel: String) {
  let joint = cwd().dir.path <> "/" <> rel

  use resolved <- result.try(
    simplifile.resolve(joint) |> result.replace_error(PathUnresolvable(joint)),
  )

  use _ <- result.map(
    simplifile.create_directory_all(resolved)
    |> result.replace_error(ErrorCreatingDir(joint)),
  )

  resolved |> Path |> DirPath
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

pub fn site_path_to_string(p: SitePath) {
  p.slug
}

pub fn site_path_to_href(p: SitePath) {
  p.slug |> attribute.href
}

pub fn read_text_file(p: FilePath) {
  simplifile.read(p.file.path)
  |> result.replace_error(ErrorReadingTextFile(p.file.path))
}

pub fn write_site_file(out_dir: DirPath, path: SitePath, content: String) {
  let to_resolve = out_dir.dir.path <> path.slug
  use resolved <- result.try(
    simplifile.resolve(to_resolve)
    |> result.replace_error(PathUnresolvable(to_resolve)),
  )

  let parent_to_resolve = resolved <> "/.."
  use dir <- result.try(
    simplifile.resolve(parent_to_resolve)
    |> result.replace_error(PathUnresolvable(parent_to_resolve)),
  )

  use _ <- result.try(
    simplifile.create_directory_all(dir)
    |> result.replace_error(ErrorCreatingDir(dir)),
  )

  simplifile.write(resolved, content)
  |> result.replace_error(ErrorWritingTextFile(resolved))
}

pub type Extension {
  MD
  MDX
  HTML
}

fn to_suffix(ext: Extension) {
  case ext {
    MD -> ".md"
    MDX -> ".mdx"
    HTML -> ".html"
  }
}

pub fn site_path_from_string(site_path: String) {
  let assert Ok(re) = regexp.from_string("^\\/.+\\.\\w+$")

  case regexp.check(re, site_path) {
    True -> Ok(SitePath(site_path))
    False -> Error(InvalidSitePath(site_path))
  }
}

pub fn to_site_path(
  dir: DirPath,
  p: FilePath,
  replace_ext: dict.Dict(Extension, Extension),
) -> SitePath {
  let path = p.file.path

  let input_ext = dict.keys(replace_ext)
  let ext =
    list.find(input_ext, fn(e) { string.ends_with(path, e |> to_suffix) })

  let from_base = string.remove_prefix(path, dir.dir.path)

  case ext {
    Error(_) -> from_base
    Ok(e) -> {
      let without_ext = string.remove_suffix(from_base, e |> to_suffix)
      let new_ext =
        dict.get(replace_ext, e) |> result.map(to_suffix) |> result.unwrap("")

      without_ext <> new_ext
    }
  }
  |> SitePath
}

pub fn has_ext(file: FilePath, exts: List(Extension)) {
  let suffixes = exts |> list.map(to_suffix)

  list.any(suffixes, string.ends_with(file.file.path, _))
}
