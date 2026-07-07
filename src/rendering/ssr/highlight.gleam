import gleam/javascript/promise.{type Promise}
import js/dom
import rendering/assets.{type Page, Page}

pub fn render_all(page: Page) -> Promise(Result(Page, a)) {
  use html <- promise.await(dom.highlight(page.html))

  Ok(Page(..page, html:)) |> promise.resolve
}
