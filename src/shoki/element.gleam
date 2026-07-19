import gleam/dict
import gleam/list
import gleam/set
import gleam/string
import glentities/html_encoder
import shoki/internal/html

pub opaque type Attr {
  Attr(name: String, value: String)
}

pub opaque type Element {
  Element(tag: String, attrs: List(Attr), children: List(Element))
  Text(skip_encode: Bool, text: String)
}

pub opaque type DocumentNode {
  DocumentNode(doctype: DocumentTypeNode, children: List(Element))
}

pub opaque type DocumentTypeNode {
  DocumentTypeHTML
}

pub fn parse_doc(html str: String, with custom) {
  parse(str, custom)
  |> DocumentNode(DocumentTypeHTML, _)
}

pub fn parse(html str: String, with custom) {
  str
  |> html.parse
  |> to_elements_rec(custom)
}

fn to_attr(attr: html.Attr) {
  let #(name, value) = attr

  Attr(name:, value:)
}

/// List of void elements: https://developer.mozilla.org/en-US/docs/Glossary/Void_element
fn void_tags() {
  [
    "area",
    "base",
    "br",
    "col",
    "embed",
    "hr",
    "img",
    "input",
    "link",
    "meta",
    "param ",
    "source",
    "track",
    "wbr",
  ]
  |> set.from_list
}

pub fn to_elements_rec(parsed: List(html.Parsed), with custom) {
  use node <- list.map(parsed)

  let el = case node {
    html.Text(text:) -> Text(False, text)
    html.Node(tag:, attributes:, children:) -> {
      let attrs = attributes |> list.map(to_attr)
      Element(tag, attrs, to_elements_rec(children, custom))
    }
    html.Script(attributes:, script: content) -> {
      let attrs = attributes |> list.map(to_attr)
      script(attrs, content)
    }
    html.Style(attributes:, stylesheet: content) -> {
      let attrs = attributes |> list.map(to_attr)
      style(attrs, content)
    }
  }

  case el {
    Text(_, _) -> el
    Element(_, _, _) -> {
      case dict.get(custom, element) {
        Error(_) -> el
        Ok(transform) -> transform(element)
      }
    }
  }
}

pub fn script(attrs, script) {
  Element("script", attrs, [Text(True, script)])
}

pub fn style(attrs, script) {
  Element("style", attrs, [Text(True, script)])
}

const doctype_html = "<!doctype html>"

fn inside_tag(attrs: List(Attr)) {
  attrs
  |> list.map(fn(a) {
    let encoded = html_encoder.encode(a.value)

    a.name <> "=\"" <> encoded <> "\""
  })
  |> string.join(" ")
}

// TODO: create real indent structure for formatting
const indent = "\n"

fn opening(tag, attrs) {
  let attrs = inside_tag(attrs)
  let content = case attrs {
    "" -> ""
    _ -> " " <> attrs
  }

  indent <> "<" <> tag <> content <> ">"
}

fn closing(tag) {
  "</" <> tag <> ">"
}

fn self_closing(tag, attrs) {
  let attrs = inside_tag(attrs)
  let content = case attrs {
    "" -> " "
    _ -> " " <> attrs <> " "
  }

  indent <> "<" <> tag <> content <> "/>"
}

fn elem_to_string_rec(el: Element, voids) {
  case el {
    Text(skip_encode:, text:) -> {
      case skip_encode {
        True -> text
        False -> html_encoder.encode(text)
      }
    }
    Element(tag:, attrs:, children:) -> {
      case voids |> set.contains(tag) {
        True -> self_closing(tag, attrs)
        False ->
          opening(tag, attrs)
          <> children
          |> list.map(elem_to_string_rec(_, voids))
          |> string.join("")
          <> closing(tag)
      }
    }
  }
}

fn doctype_to_string(doctype: DocumentTypeNode) {
  case doctype {
    DocumentTypeHTML -> doctype_html
  }
}

pub fn to_string(el: Element) {
  elem_to_string_rec(el, void_tags())
}

pub fn to_document_string(doc: DocumentNode) {
  doctype_to_string(doc.doctype)
  <> doc.children
  |> list.map(elem_to_string_rec(_, void_tags()))
  |> string.join("\n")
}

fn attr(name: String, value: String) {
  Attr(name:, value:)
}

pub fn href(value: String) {
  attr("href", value)
}

pub fn element(tag, attrs, children) {
  Element(tag:, attrs:, children:)
}

pub fn attribute(name, value) {
  Attr(name:, value:)
}

pub fn text(text) {
  Text(False, text)
}

pub fn raw_text(text) {
  Text(True, text)
}

pub fn to_html_document(root) {
  DocumentNode(DocumentTypeHTML, [root])
}
