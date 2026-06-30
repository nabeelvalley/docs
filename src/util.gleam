import gleam/javascript/promise
import gleam/list
import gleam/result
import gleam/string

/// A drop-in replacement for result.try when in a promise context.
/// Wraps results in a promise so that they can be used in `use` statements
/// within a function ensuring consistent returns
pub fn try_resolve(result, cb) {
  case result {
    Ok(ok) -> cb(ok)
    Error(err) -> promise.resolve(Error(err))
  }
}

/// Simplifies mapping List(Result) to Result(List)
/// if you can, it would be better to convert a list.map to a list.try_map
/// which would avoid needing this function altogether
pub fn try_list(res, cb) {
  result.try(
    res
      |> result.all,
    cb,
  )
}

/// Map over result object and merge error messages
pub fn try_all_merge_errors(res: List(Result(ok, String)), cb) {
  let oks = res |> list.filter_map(fn(i) { i })
  let errs =
    res
    |> list.filter_map(fn(i) {
      case i {
        Ok(ok) -> Error(ok)
        Error(err) -> Ok(err)
      }
    })

  case errs {
    [] -> cb(oks)
    [_, ..] -> Error(errs |> string.join("\n"))
  }
}
