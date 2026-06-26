import gleam/javascript/promise

/// A drop-in replacement for result.try when in a promise context.
/// Wraps results in a promise so that they can be used in `use` statements
/// within a function ensuring consistent returns
pub fn try_resolve(result, cb) {
  promise.try_await(result |> promise.resolve, cb)
}
