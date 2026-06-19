@external(javascript, "./dom_ffi.mjs", "pretty")
pub fn pretty(_html: String) -> String {
  panic as "not supported for the given target"
}

@external(javascript, "./dom_ffi.mjs", "update")
pub fn update(
  html _html: String,
  tag _tag: String,
  visit _visit: fn(String, List(#(String, String))) -> String,
) -> String {
  panic as "not supported for the given target"
}
