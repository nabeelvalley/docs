import gleam/javascript/promise.{type Promise}

@external(javascript, "./shiki_ffi.mjs", "highlight")
pub fn highlight(_html: String) -> Promise(String) {
  panic as "not supported for the given target"
}
