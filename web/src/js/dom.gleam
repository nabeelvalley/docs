import gleam/list

@external(javascript, "./dom_ffi.mjs", "pretty")
pub fn pretty(_html: String) -> String {
  panic as "not supported for the given target"
}

pub type JSRootRef

pub type JSNodeRef

pub type JSNode =
  #(JSNodeRef, Attrs, String)

pub type JSNodeUpdate =
  #(JSNodeRef, String)

pub type Attrs =
  List(#(String, String))

@external(javascript, "./dom_ffi.mjs", "getNodes")
fn raw_get_nodes(_html: String, _tag: String) -> #(JSRootRef, List(JSNode)) {
  panic as "not supported for the given target"
}

@external(javascript, "./dom_ffi.mjs", "updateNodes")
fn raw_update_nodes(_root: JSRootRef, _els: List(JSNodeUpdate)) -> String {
  panic as "not supported for the given target"
}

pub type Node {
  Node(node: JSNodeRef, attrs: Attrs, content: String)
}

pub type NodeUpdate {
  NodeUpdate(node: JSNodeRef, html: String)
}

/// Update HTML content of all instances of a given tag
pub fn get_nodes(
  html html: String,
  tag tag: String,
) -> #(JSRootRef, List(Node)) {
  let #(root, raw_nodes) = raw_get_nodes(html, tag)

  let nodes =
    raw_nodes
    |> list.map(fn(node) {
      let #(ref, attrs, content) = node
      Node(ref, attrs, content)
    })

  #(root, nodes)
}

pub fn update_nodes(root: JSRootRef, nodes: List(NodeUpdate)) -> String {
  let updates =
    nodes
    |> list.map(fn(node) { #(node.node, node.html) })

  raw_update_nodes(root, updates)
}
