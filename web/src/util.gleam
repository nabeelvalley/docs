import gleam/javascript/promise
import gleam/result

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
pub fn try_list(res, cb) {
  result.try(
    res
      |> result.all,
    cb,
  )
}
