import consts
import gleam/list
import gleam/option.{None, Some}
import mellie
import mellie/attr
import shoki
import shoki/date
import shoki/internal/date as idate
import shoki/internal/fs

pub type RSSItem {
  RSSItem(
    title: String,
    path: fs.SitePath,
    description: option.Option(String),
    date: option.Option(date.IsoDate),
    content: option.Option(mellie.ElementTree),
  )
}

pub type RSSFeed {
  RSSFeed(title: String, description: String, base_url: String)
}

fn rss_path() {
  let assert Ok(path) = fs.site_path_from_string("/feed/rss.xml")
  path
}

pub fn with_rss(
  pipeline: shoki.Pipeline(a, b),
  feed: RSSFeed,
  get_item: fn(b, shoki.HTMLFile) -> option.Option(RSSItem),
) {
  shoki.with_summary(pipeline, fn(agg, assets) {
    let items =
      list.map(assets, fn(asset) {
        use html <- shoki.if_html(asset, None)
        get_item(agg, html)
      })
      |> option.values

    render(feed, items) |> shoki.text_file(rss_path(), _) |> list.wrap |> Ok
  })
}

pub fn render(feed: RSSFeed, pages: List(RSSItem)) {
  let assert Ok(blog_path) = fs.site_path_from_string("/blog")
  let assert Ok(rss_only_path) = fs.site_path_from_string("/rss-only")
  let rss_pages =
    pages
    |> list.filter(fn(p) {
      fs.site_path_starts_with(p.path, blog_path)
      || fs.site_path_starts_with(p.path, rss_only_path)
    })

  let feed =
    rss_pages
    |> list.map(fn(p) {
      let url = consts.site_base_url <> p.path |> fs.site_path_to_string

      [
        Some(title(p.title)),
        Some(link(url)),
        Some(guid(url)),
        option.map(p.description, description),
        option.map(p.date, pub_date),
        p.content |> option.map(content),
      ]
      |> option.values
      |> item
    })
    |> channel(feed, _)
    |> rss
    |> to_xml

  feed
}

fn xml_element(tag, attrs, children) {
  mellie.element(tag, attrs, children)
}

fn channel(feed: RSSFeed, items) {
  xml_element("channel", [], [
    title(feed.title),
    description(feed.description),
    link(feed.base_url),
    atom_link(),
    ..items
  ])
}

fn rss(channel) {
  xml_element(
    "rss",
    [
      mellie.attribute(
        "xmlns:content",
        "http://purl.org/rss/1.0/modules/content/",
      ),
      mellie.attribute("xmlns:atom", "http://www.w3.org/2005/Atom"),
      mellie.attribute("version", "2.0"),
    ],
    [channel],
  )
}

fn to_xml(els) {
  els |> mellie.element_to_xml_document_string
}

fn item(items) {
  xml_element("item", [], items)
}

fn atom_link() {
  xml_element(
    "atom:link",
    [
      attr.href(consts.site_base_url <> "/feed/rss.xml"),
      attr.rel("self"),
      attr.type_("application/rss+xml"),
    ],
    [],
  )
}

fn title(s) {
  xml_element("title", [], [mellie.text(s)])
}

fn link(s) {
  xml_element("link", [], [mellie.text(s)])
}

fn guid(s) {
  xml_element("guid", [mellie.attribute("isPermaLink", "true")], [
    mellie.text(s),
  ])
}

fn description(s) {
  xml_element("description", [], [mellie.text(s)])
}

fn pub_date(d) {
  xml_element("pubDate", [], [mellie.text(idate.to_rss_pub_date(d))])
}

fn content(s) {
  xml_element("content:encoded", [], [
    mellie.text(s |> mellie.element_to_string),
  ])
}
