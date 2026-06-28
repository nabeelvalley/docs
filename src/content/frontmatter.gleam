import content/fs
import date
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import yamleam

pub type Layout {
  ArticleLayout
  GalleryLayout
}

pub type Frontmatter {
  Frontmatter(
    title: Option(String),
    date: Option(date.IsoDate),
    description: Option(String),
    published: Bool,
    feature: Bool,
    rss_only: Bool,
    layout: Layout,
    tags: List(String),
  )
}

pub type Extracted {
  Extracted(frontmatter: Frontmatter, content: String)
}

type Parts {
  Parts(frontmatter: String, content: String)
}

pub fn extract(file: fs.File) {
  use parts <- result.try(separate(file))
  use parsed <- result.try(parse(parts.frontmatter))

  Ok(Extracted(parsed, parts.content))
}

fn separate(file: fs.File) -> Result(Parts, String) {
  let lines = file.content |> string.trim |> string.split("\n")

  let not_end = fn(str) { !string.starts_with(str, "---") }

  case lines {
    ["---", ..rest] -> {
      let #(front, content) = list.split_while(rest, not_end)

      Ok(Parts(
        front |> string.join("\n"),
        content |> list.drop(1) |> string.join("\n"),
      ))
    }
    _ -> Error("No frontmatter present:" <> file.path)
  }
}

fn parse(frontmatter: String) -> Result(Frontmatter, String) {
  yamleam.parse(frontmatter, frontmatter_decoder())
  |> result.replace_error(
    "error decoding frontmatter, given:\n\n" <> frontmatter,
  )
}

fn frontmatter_decoder() -> decode.Decoder(Frontmatter) {
  let decode_bool = fn(field, a) {
    decode.optional_field(field, False, decode.bool, a)
  }

  let decode_str = fn(field, a) {
    decode.optional_field(field, None, decode.optional(decode.string), a)
  }

  use title <- decode_str("title")
  use date_str <- decode_str("date")

  use description <- decode_str("description")
  use layout_str <- decode_str("layout")

  use published <- decode_bool("published")
  use feature <- decode_bool("feature")
  use rss_only <- decode_bool("rss_only")

  use tags <- decode.optional_field("tags", [], decode.list(decode.string))

  let date =
    option.map(date_str, date.parse)
    |> option.map(option.from_result)
    |> option.flatten

  let layout = case layout_str {
    Some("gallery") -> GalleryLayout
    _ -> ArticleLayout
  }

  decode.success(Frontmatter(
    title:,
    date:,
    description:,
    published:,
    feature:,
    rss_only:,
    layout:,
    tags:,
  ))
}
