import consts
import gleam/list
import gleam/option.{Some}
import gleam/string
import js/date
import js/dom
import lustre/attribute
import lustre/element
import rendering/assets.{type Page, XMLFeed}

pub fn render(pages: List(Page)) {
  let rss_pages =
    pages
    |> list.filter(fn(p) {
      string.starts_with(p.slug, "/blog")
      || string.starts_with(p.slug, "/rss-only")
    })
    |> assets.sort_by_date

  let feed =
    rss_pages
    |> list.map(fn(p) {
      let url = consts.site_base_url <> p.slug
      let nodes = dom.get_nodes(tag: "main", html: p.html)
      let main = nodes.nodes |> list.map(fn(n) { n.content }) |> string.join("")

      [
        Some(title(p.meta.title)),
        Some(link(url)),
        Some(guid(url)),
        option.map(p.meta.description, description),
        option.map(p.meta.date, pub_date),
        Some(content(main)),
      ]
      |> option.values
      |> item
    })
    |> channel
    |> rss
    |> to_xml

  XMLFeed("/feed/rss", feed)
}

fn xml_element(tag, attrs, children) {
  let self_closing = case children {
    [] -> True
    _ -> False
  }

  element.advanced("", tag, attrs, children, self_closing, False)
}

fn channel(items) {
  xml_element("channel", [], [
    title("Nabeel Valley"),
    description("Nabeel's Blog"),
    link(consts.site_base_url),
    atom_link(),
    ..items
  ])
}

fn rss(channel) {
  xml_element(
    "rss",
    [
      attribute.attribute(
        "xmlns:content",
        "http://purl.org/rss/1.0/modules/content/",
      ),
      attribute.attribute("xmlns:atom", "http://www.w3.org/2005/Atom"),
      attribute.attribute("version", "2.0"),
    ],
    [channel],
  )
}

fn to_xml(els) {
  let content = els |> element.to_string

  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" <> content |> string.trim
}

fn item(items) {
  xml_element("item", [], items)
}

fn atom_link() {
  xml_element(
    "atom:link",
    [
      attribute.href(consts.site_base_url <> "/feed/rss.xml"),
      attribute.rel("self"),
      attribute.type_("application/rss+xml"),
    ],
    [],
  )
}

fn title(s) {
  xml_element("title", [], [element.text(s)])
}

fn link(s) {
  xml_element("link", [], [element.text(s)])
}

fn guid(s) {
  xml_element("guid", [attribute.attribute("isPermaLink", "true")], [
    element.text(s),
  ])
}

fn description(s) {
  xml_element("description", [], [element.text(s)])
}

fn pub_date(d) {
  xml_element("pubDate", [], [element.text(date.to_rss_pub_date(d))])
}

fn content(s) {
  let main = element.unsafe_raw_html("", "main", [], s)
  let content = main |> element.to_string
  xml_element("content:encoded", [], [element.text(content)])
}
