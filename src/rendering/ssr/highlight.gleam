import js/dom
import rendering/assets.{type Page, Page}

pub fn render_all(page: Page) -> Result(Page, String) {
  let html = dom.highlight(page.html)

  Ok(Page(..page, html:))
}
