import gleam/dynamic/decode
import gleam/option.{type Option}
import shoki/internal/date.{type IsoDate}
import shoki/internal/fs
import shoki/internal/pipeline

/// Basic frontmatter type for the default template
pub opaque type Frontmatter {
  Frontmatter(
    draft: Bool,
    title: Option(String),
    description: Option(String),
    date: Option(IsoDate),
    tags: List(String),
  )
}

fn frontmatter_decoder() -> decode.Decoder(Frontmatter) {
  use draft <- decode.field("draft", decode.bool)
  use title <- decode.field("title", decode.optional(decode.string))
  use description <- decode.field("description", decode.optional(decode.string))
  use date <- decode.field("date", date.date_decoder())
  use tags <- decode.field("tags", decode.list(decode.string))

  decode.success(Frontmatter(draft:, title:, description:, date:, tags:))
}

pub fn create_pipeline(content_dir: fs.DirPath) {
  pipeline.from_markdown(content_dir, frontmatter_decoder(), fn(_, _) { todo })
}
