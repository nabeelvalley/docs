import filepath
import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import mellie/attr
import shoki/error.{
  type ShokiResult, DirNotFound, ErrorCopyingDir, ErrorCreatingDir,
  ErrorDeletingDir, ErrorReadingTextFile, ErrorWritingTextFile, InvalidSitePath,
  PathUnresolvable,
}
import simplifile

/// An absolute path based on the filesystem root
pub opaque type Path {
  Path(path: String)
}

/// An absolute path based on the site root
pub opaque type SitePath {
  SitePath(slug: String)
}

pub fn resolve(dir: Path, relative: String) {
  let joined = filepath.join(dir.path, relative)
  joined
  |> filepath.expand
  |> result.replace_error(PathUnresolvable(joined))
  |> result.map(Path)
}

// TODO: make this function not the slowest thing in the world
pub fn parent(path: Path) {
  filepath.split(path.path)
  |> list.reverse
  |> list.drop(1)
  |> list.reverse
  |> list.reduce(filepath.join)
  |> result.map(Path)
  |> result.replace_error(error.ParentDirNotFound(path.path))
}

pub fn cwd() {
  // something would be very wrong if we couldn't resolve the current dir
  let assert Ok(cwd) = simplifile.resolve(".")

  cwd |> Path
}

pub fn from_cwd(rel: String) {
  resolve(cwd(), rel)
}

pub fn delete_dir(dir: Path) {
  let path = dir.path
  simplifile.delete(path) |> result.replace_error(ErrorDeletingDir(path))
}

pub fn delete_dir_if_exists(dir: Path) {
  case is_dir(dir) {
    False -> Ok(Nil)
    True -> {
      let path = dir.path
      simplifile.delete(path) |> result.replace_error(ErrorDeletingDir(path))
    }
  }
}

pub fn ensure_dir(path: Path) {
  case is_dir(path) {
    True -> Ok(Nil)
    False ->
      simplifile.create_directory_all(path.path)
      |> result.replace_error(error.ErrorCreatingDir(path.path))
  }
}

pub fn ensure_relative_dir(rel: String) {
  use joined <- result.try(resolve(cwd(), rel))

  use resolved <- result.try(
    simplifile.resolve(joined.path)
    |> result.replace_error(PathUnresolvable(joined.path)),
  )

  use _ <- result.map(
    simplifile.create_directory_all(resolved)
    |> result.replace_error(ErrorCreatingDir(joined.path)),
  )

  resolved |> Path
}

fn is_file(path: Path) {
  simplifile.is_file(path.path) |> result.unwrap(False)
}

fn is_dir(path: Path) {
  simplifile.is_directory(path.path) |> result.unwrap(False)
}

pub fn ls_dir(at: Path) -> ShokiResult(List(Path)) {
  use paths <- result.try(
    simplifile.read_directory(at.path)
    |> result.replace_error(DirNotFound(at.path)),
  )

  use resolved <- result.try(
    paths |> list.map(resolve(at, _)) |> error.collate_errors,
  )

  let files = resolved |> list.filter(is_file)

  let dirs = resolved |> list.filter(is_dir)
  use subdirs <- result.try(dirs |> list.map(ls_dir) |> result.all)

  files
  |> list.append(subdirs |> list.flatten)
  |> Ok
}

/// Converts a path to string within the current working directory.
/// This should only be used for printing data and not for working
/// with paths
pub fn path_to_string(p: Path) {
  let cwd = cwd().path <> "/"

  p.path |> string.remove_prefix(matching: cwd)
}

/// Gets the absolute path as a string
pub fn to_abs_string(p: Path) {
  p.path
}

pub fn site_path_to_string(p: SitePath) {
  p.slug
}

pub fn site_path_to_href(p: SitePath) {
  p.slug |> attr.href
}

pub fn read_text_file(p: Path) {
  simplifile.read(p.path)
  |> result.replace_error(ErrorReadingTextFile(p.path))
}

pub fn site_path_to_path(out_dir: Path, path: SitePath) {
  let to_resolve = out_dir.path <> path.slug

  to_resolve
  |> simplifile.resolve
  |> result.replace_error(PathUnresolvable(to_resolve))
  |> result.map(Path)
}

pub fn write_site_file(out_dir: Path, path: SitePath, content: String) {
  use resolved <- result.try(site_path_to_path(out_dir, path))
  let parent_to_resolve = resolved.path <> "/.."
  use dir <- result.try(
    simplifile.resolve(parent_to_resolve)
    |> result.replace_error(PathUnresolvable(parent_to_resolve)),
  )

  use _ <- result.try(
    simplifile.create_directory_all(dir)
    |> result.replace_error(ErrorCreatingDir(dir)),
  )

  simplifile.write(resolved.path, content)
  |> result.replace_error(ErrorWritingTextFile(resolved.path))
}

pub type Extension {
  MD
  MDX
  HTML
  JPG
  PNG
  JPEG
  WEBP
}

fn to_suffix(ext: Extension) {
  case ext {
    MD -> ".md"
    MDX -> ".mdx"
    HTML -> ".html"
    PNG -> ".png"
    JPG -> ".jpg"
    JPEG -> ".jpeg"
    WEBP -> ".webp"
  }
}

pub fn site_path_from_string(site_path: String) {
  case filepath.is_absolute(site_path) {
    True -> Ok(SitePath(site_path))
    False -> Error(InvalidSitePath(site_path))
  }
}

pub fn to_site_path(
  dir: Path,
  p: Path,
  replace_ext: dict.Dict(Extension, Extension),
) -> SitePath {
  let path = p.path

  let input_ext = dict.keys(replace_ext)
  let ext =
    list.find(input_ext, fn(e) { string.ends_with(path, e |> to_suffix) })

  let from_base = string.remove_prefix(path, dir.path)

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

pub fn has_ext(file: Path, exts: List(Extension)) {
  let suffixes = exts |> list.map(to_suffix)

  list.any(suffixes, string.ends_with(file.path, _))
}

pub fn copy_site_dir(out: Path, from: Path, to: SitePath) {
  let input = from.path
  let output = out.path <> to.slug

  simplifile.copy_directory(input, output)
  |> result.replace_error(ErrorCopyingDir(
    "from: " <> input <> " to: " <> output,
  ))
}

pub fn file_name_only(file: Path) {
  file.path |> filepath.base_name |> filepath.strip_extension
}

/// Just does a string concat of two site paths, dropping the leading slash of the second path
pub fn concat_site_path(a: SitePath, b: SitePath) {
  case b.slug {
    "/" <> slug -> a.slug <> "/" <> slug
    slug -> a.slug <> "/" <> slug
  }
  |> SitePath
}

pub fn site_path_starts_with(path, prefix) {
  let path = path |> site_path_to_string
  let start = prefix |> site_path_to_string

  path |> string.starts_with(start)
}
