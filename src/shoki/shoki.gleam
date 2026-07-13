pub type ShokiResult(r) =
  Result(r, ShokiErr)

pub type ShokiErr {
  FileNotFound(String)
  DirNotFound(String)
  PathUnresolvable(String)
}
