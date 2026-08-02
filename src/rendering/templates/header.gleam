import consts
import mellie/attr.{class, href}
import mellie/html.{a, header, text}
import rendering/templates/navigation

pub fn render() {
  header([class("site-header")], [
    a([href("/")], [text(consts.site_title)]),
    navigation.render(),
  ])
}
