pub type ShokiResult(r) =
  Result(r, ShokiErr)

pub type ShokiErr {
  FileNotFound(String)
  ErrorReadingTextFile(String)
  ErrorReadingFrontmatter(String)
  DirNotFound(String)
  PathUnresolvable(String)
  DateParseError(String)
}
