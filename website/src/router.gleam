import routes/docs_index
import routes/docs_page
import routes/index
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> index.page(req)

    // This matches `/docs`.
    ["docs"] -> docs_index.page(req)

    // This matches `/docs/:id`.
    ["docs", id] -> docs_page.page(req, id)

    // This matches all other paths.
    _ -> wisp.not_found()
  }
}
