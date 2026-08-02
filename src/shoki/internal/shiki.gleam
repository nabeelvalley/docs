import gleam/javascript/promise.{type Promise}

/// Returns the highlighted code in `body>pre` with the rest of the expected content
@external(javascript, "./shiki_ffi.mjs", "highlight")
pub fn highlight(
  _code: String,
  _lang: String,
) -> Promise(Result(String, String)) {
  panic as "not supported for the given target"
}
