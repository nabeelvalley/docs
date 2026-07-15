import gleam/list
import gleam/result
import gleam/string

pub type ShokiResult(r) =
  Result(r, ShokiErr)

pub type ShokiErr {
  Context(String, ShokiErr)
  Collated(List(ShokiErr))
  FileNotFound(String)
  ErrorReadingTextFile(String)
  ErrorReadingFrontmatter(String)
  DirNotFound(String)
  ErrorCopyingDir(String)
  ErrorCreatingDir(String)
  ErrorDeletingDir(String)
  PathUnresolvable(String)
  ErrorWritingTextFile(String)
  DateParseError(String)
  InvalidSitePath(String)
  InvalidSiteDir(String)
}

/// A drop-in replacement for result.all for merging errors into a single error object
pub fn collate_errors(results: List(ShokiResult(r))) -> ShokiResult(List(r)) {
  let #(oks, errs) = result.partition(results)

  case errs {
    [] -> Ok(oks)
    _ -> Error(Collated(errs))
  }
}

/// Add some context to an error
pub fn error_context(err, msg) {
  Context(msg, err)
}

fn indent_str(str, i) {
  let indent = string.repeat(" ", i * 2)
  str
  |> string.split("\n")
  |> list.map(string.append(indent, _))
  |> string.join("\n")
}

fn error_to_string_rec(err: ShokiErr, indent) {
  case err {
    Context(msg, inner) -> msg <> "\n" <> error_to_string_rec(inner, indent + 1)
    Collated(errs) ->
      errs |> list.map(error_to_string_rec(_, indent)) |> string.join("\n")

    FileNotFound(msg) -> "FileNotFound: " <> msg
    ErrorReadingTextFile(msg) -> "ErrorReadingTextFile: " <> msg
    ErrorReadingFrontmatter(msg) -> "ErrorReadingFrontmatter: " <> msg
    DirNotFound(msg) -> "DirNotFound: " <> msg
    ErrorCreatingDir(msg) -> "ErrorCreatingDir: " <> msg
    ErrorDeletingDir(msg) -> "ErrorDeletingDir: " <> msg
    PathUnresolvable(msg) -> "PathUnresolvable: " <> msg
    ErrorWritingTextFile(msg) -> "ErrorWritingTextFile: " <> msg
    DateParseError(msg) -> "DateParseError: " <> msg
    InvalidSitePath(msg) -> "InvalidSitePath: " <> msg
    InvalidSiteDir(msg) -> "InvalidSiteDir: " <> msg
    ErrorCopyingDir(msg) -> "Error Copying Dir: " <> msg
  }
  |> indent_str(indent)
}

pub fn error_to_string(err) {
  error_to_string_rec(err, 0)
}
