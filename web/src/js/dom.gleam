import gleam/list

@external(javascript, "./dom_ffi.mjs", "pretty")
pub fn pretty(_html: String) -> String {
  panic as "not supported for the given target"
}

type RootRef

type NodeRef

type Node =
  #(NodeRef, List(#(String, String)), String)

type NodeUpdate =
  #(NodeRef, String)

@external(javascript, "./dom_ffi.mjs", "getNodes")
fn get_nodes(_html: String, _tag: String) -> #(RootRef, List(Node)) {
  panic as "not supported for the given target"
}

@external(javascript, "./dom_ffi.mjs", "updateNodes")
fn update_nodes(_root: RootRef, _els: List(NodeUpdate)) -> String {
  panic as "not supported for the given target"
}

pub fn update(
  html html: String,
  tag tag: String,
  visit visit: fn(String, List(#(String, String))) -> String,
) -> String {
  let #(root, nodes) = get_nodes(html, tag)

  let updates =
    list.map(nodes, fn(node) {
      let #(ref, attrs, content) = node
      let html = visit(content, attrs)

      #(ref, html)
    })

  update_nodes(root, updates)
}
