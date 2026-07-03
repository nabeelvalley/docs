import consts
import lustre/attribute.{class, href}
import lustre/element/html.{a, header, text}
import rendering/templates/navigation

pub fn render() {
  header([class("site-header")], [
    a([href("/")], [text(consts.site_title)]),
    navigation.render(),
  ])
}
