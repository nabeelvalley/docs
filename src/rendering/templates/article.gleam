import mellie/attr
import mellie/html
import rendering/assets.{type Meta}
import rendering/templates/base

pub fn render(body, meta: Meta) {
  html.article([attr.class("site-article")], [
    html.h1([], [html.text(meta.title)]),
    body,
  ])
  |> base.render(meta)
}
