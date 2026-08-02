pub type Attr =
  #(String, String)

pub type Parsed {
  Text(text: String)
  Node(tag: String, attributes: List(Attr), children: List(Parsed))

  /// Script tags are handled differently since their content
  /// should not be escaped when converting to Lustre
  Script(attributes: List(Attr), script: String)

  /// Style tags are handled differently since their content
  /// should not be escaped when converting to Lustre
  Style(attributes: List(Attr), stylesheet: String)
}

@external(javascript, "./html_ffi.mjs", "pretty")
pub fn pretty(_html: String) -> String {
  panic as "not supported for the given target"
}

@external(javascript, "./html_ffi.mjs", "parse")
pub fn parse(_html: String) -> List(Parsed) {
  panic as "not supported for the given target"
}
