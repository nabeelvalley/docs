import gleam/dict
import gleam/list
import gleam/set
import gleam/string
import glentities/html_encoder
import lustre/element
import shoki/internal/html

pub opaque type Attr {
  Attr(name: String, value: String)
}

pub opaque type Element {
  Element(
    tag: String,
    attrs: List(Attr),
    is_void: Bool,
    children: List(ChildNode),
  )
}

pub opaque type ChildNode {
  ElementNode(element: Element)
  TextNode(skip_encode: Bool, text: String)
}

pub opaque type DocumentNode {
  DocumentNode(doctype: DocumentTypeNode, children: List(ChildNode))
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
  |> to_elements_rec(void_tags(), custom)
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

pub fn to_elements_rec(parsed: List(html.Parsed), voids, with custom) {
  use node <- list.map(parsed)

  let el = case node {
    html.Text(text:) -> TextNode(False, text)
    html.Node(tag:, attributes:, children:) -> {
      let attrs = attributes |> list.map(to_attr)
      Element(
        tag,
        attrs,
        voids |> set.contains(tag),
        to_elements_rec(children, voids, custom),
      )
      |> ElementNode
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
    TextNode(_, _) -> el
    ElementNode(element:) -> {
      case dict.get(custom, element.tag) {
        Error(_) -> el
        Ok(transform) -> transform(element) |> ElementNode
      }
    }
  }
}

pub fn script(attrs, script) {
  Element("script", attrs, False, [TextNode(True, script)]) |> ElementNode
}

pub fn style(attrs, script) {
  Element("style", attrs, False, [TextNode(True, script)]) |> ElementNode
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

fn opening(el: Element) {
  let attrs = inside_tag(el.attrs)
  let content = case attrs {
    "" -> ""
    _ -> " " <> attrs
  }

  indent <> "<" <> el.tag <> content <> ">"
}

fn closing(el: Element) {
  "</" <> el.tag <> ">"
}

fn self_closing(el: Element) {
  let attrs = inside_tag(el.attrs)
  let content = case attrs {
    "" -> " "
    _ -> " " <> attrs <> " "
  }

  indent <> "<" <> el.tag <> content <> "/>"
}

fn node_to_string_rec(el: ChildNode, voids) {
  case el {
    ElementNode(element:) -> elem_to_string_rec(element, voids)
    TextNode(skip_encode:, text:) ->
      case skip_encode {
        True -> text
        False -> html_encoder.encode(text)
      }
  }
}

fn elem_to_string_rec(el: Element, voids) {
  case voids |> set.contains(el.tag) {
    True -> self_closing(el)
    False ->
      opening(el)
      <> el.children
      |> list.map(node_to_string_rec(_, voids))
      |> string.join("")
      <> closing(el)
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

pub fn node_to_string(el: ChildNode) {
  node_to_string_rec(el, void_tags())
}

pub fn to_document_string(doc: DocumentNode) {
  doctype_to_string(doc.doctype)
  <> doc.children
  |> list.map(node_to_string_rec(_, void_tags()))
  |> string.join("\n")
}

fn attr(name: String, value: String) {
  Attr(name:, value:)
}

pub fn href(value: String) {
  attr("href", value)
}

/// TODO: remove this once all lustre stuff have been removed
pub fn tmp_from_lustre_please_remove(el: element.Element(Nil)) {
  el |> element.to_document_string |> parse(dict.new())
}

pub fn tmp_doc_from_lustre_please_remove(el: element.Element(Nil)) {
  tmp_from_lustre_please_remove(el) |> DocumentNode(DocumentTypeHTML, _)
}

/// TODO: remove this once all lustre stuff have been removed
pub fn tmp_to_lustre_please_remove(els: List(ChildNode)) {
  els
  |> list.map(node_to_string)
  |> string.join("")
  |> element.unsafe_raw_html("", "div", [], _)
}
