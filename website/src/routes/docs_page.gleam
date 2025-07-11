import gleam/http.{Get}
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn page(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("/docs/:id " <> id)

  wisp.ok()
  |> wisp.html_body(html)
}
