import gleam/javascript/promise

/// A drop-in replacement for result.try when in a promise context.
/// Wraps results in a promise so that they can be used in `use` statements
/// within a function ensuring consistent returns
pub fn try_resolve(result, cb) {
  case result {
    Ok(ok) -> cb(ok)
    Error(err) -> promise.resolve(Error(err))
  }
}

pub fn to_async2(f) {
  fn(a, b) { f(a, b) |> promise.resolve }
}

pub fn to_async1(f) {
  fn(a) { f(a) |> promise.resolve }
}
