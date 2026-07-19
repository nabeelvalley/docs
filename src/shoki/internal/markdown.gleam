import gleam/dict
import gleam/string
import shoki/element

@external(javascript, "./markdown_ffi.mjs", "parse")
fn md_to_html(_md: String) -> String {
  panic as "not supported for the given target"
}

pub fn parse(md: String) {
  md
  |> string.trim
  |> md_to_html
  |> element.parse(dict.new())
}
