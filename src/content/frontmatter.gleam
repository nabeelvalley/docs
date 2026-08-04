import date
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import charge/date as sdate
import charge/fs as sfs

pub type Layout {
  NoLayout
  ArticleLayout
  GalleryLayout
}

pub type Frontmatter {
  Frontmatter(
    title: String,
    description: Option(String),
    published: Bool,
    feature: Bool,
    layout: Layout,
    tags: List(String),
    date: Option(sdate.IsoDate),
    path: sfs.SitePath,
  )
}

pub fn decoder(path: sfs.SitePath) -> decode.Decoder(Frontmatter) {
  let decode_bool = fn(field, default, a) {
    decode.optional_field(field, default, decode.bool, a)
  }

  let decode_str = fn(field, a) {
    decode.optional_field(field, None, decode.optional(decode.string), a)
  }

  use title <- decode.field("title", decode.string)
  use description <- decode_str("description")
  use layout_str <- decode_str("layout")

  use published <- decode_bool("published", True)
  use feature <- decode_bool("feature", False)

  use tags <- decode.optional_field("tags", [], decode.list(decode.string))

  let layout = case layout_str {
    Some("gallery") -> GalleryLayout
    Some("none") -> NoLayout
    _ -> ArticleLayout
  }

  let date =
    path
    |> sfs.site_path_to_string
    |> date.parse_from_path
    |> option.from_result

  decode.success(Frontmatter(
    title:,
    description:,
    published:,
    feature:,
    layout:,
    tags:,
    date:,
    path:,
  ))
}

pub fn sort_by_date(pages: List(Frontmatter)) {
  pages
  |> list.sort(fn(a, b) {
    case a.date, b.date {
      Some(a), Some(b) -> date.compare(a, b)
      Some(_), _ -> order.Gt
      None, _ -> order.Lt
    }
  })
}

pub fn is_published(fm: Frontmatter) {
  fm.published
}
