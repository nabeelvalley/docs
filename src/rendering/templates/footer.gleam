import consts
import lustre/attribute.{rel, class, href, id}
import lustre/element/html.{a, footer, li, section, text, ul}

pub fn render() {
  footer([class("site-footer")], [
    ul([class("social")], [
      li([], [a([href(consts.linkedin_url)], [text("Linkedin")])]),
      li([], [a([href(consts.github_url), rel("me")], [text("GitHub")])]),
      li([], [a([href("/feed/rss.xml")], [text("RSS")])]),
    ]),
    section([class("webring"), attribute.aria_labelledby("webring-label")], [
      a([href(consts.webring_base_url), id("webring-label")], [text("Webring")]),
      ul([], [
        li([], [
          a([href(consts.webring_base_url <> "/previous")], [text("Previous")]),
        ]),
        li([], [
          a([href(consts.webring_base_url <> "/random")], [text("Random")]),
        ]),
        li([], [
          a([href(consts.webring_base_url <> "/next")], [text("Next")]),
        ]),
      ]),
    ]),
  ])
}
