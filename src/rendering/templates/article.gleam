import mellie/attr
import mellie/html
import rendering/templates/base

pub fn render(body, meta: base.Meta) {
  html.article([attr.class("site-article")], [
    html.h1([], [html.text(meta.title)]),
    body,
  ])
  |> base.render(meta)
}
