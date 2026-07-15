import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html

type Attrib =
  #(String, String)

pub type Parsed {
  Text(text: String)
  Node(tag: String, attributes: List(Attrib), children: List(Parsed))
  Script(attributes: List(Attrib), script: String)
  Style(attributes: List(Attrib), stylesheet: String)
}

@external(javascript, "./html_ffi.mjs", "parse")
pub fn parse(_html: String) -> List(Parsed) {
  panic as "not supported for the given target"
}

fn to_attr(attrib: Attrib) {
  let #(k, v) = attrib
  attribute.attribute(k, v)
}

pub fn to_lustre(parsed: List(Parsed)) {
  use node <- list.map(parsed)
  case node {
    Text(text:) -> html.text(text)
    Node(tag:, attributes:, children:) -> {
      let attrs = attributes |> list.map(to_attr)
      element.element(tag, attrs, to_lustre(children))
    }
    Script(attributes:, script:) -> {
      let attrs = attributes |> list.map(to_attr)
      html.script(attrs, script)
    }
    Style(attributes:, stylesheet:) -> {
      let attrs = attributes |> list.map(to_attr)
      html.style(attrs, stylesheet)
    }
  }
}
