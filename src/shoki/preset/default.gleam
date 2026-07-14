import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None}
import gleam/pair
import gleam/result
import gleam/string
import lustre/element/html
import shoki/internal/date.{type IsoDate}
import shoki/internal/fs
import shoki/internal/pipeline

/// Basic frontmatter type for the default template
pub opaque type Frontmatter {
  Frontmatter(
    draft: Bool,
    title: String,
    description: Option(String),
    date: Option(IsoDate),
    tags: List(String),
  )
}

fn frontmatter_decoder() -> decode.Decoder(Frontmatter) {
  use draft <- decode.optional_field("draft", False, decode.bool)
  use title <- decode.field("title", decode.string)
  use description <- decode.field("description", decode.optional(decode.string))
  use date <- decode.optional_field("date", None, date.date_decoder())
  use tags <- decode.optional_field("tags", [], decode.list(decode.string))

  decode.success(Frontmatter(draft:, title:, description:, date:, tags:))
}

type GroupedTags =
  Dict(String, List(Frontmatter))

pub fn group_by_tag(frontmatters: List(Frontmatter)) -> GroupedTags {
  let partial = fn(fm: Frontmatter) {
    dict.from_list(fm.tags |> list.map(pair.new(_, [fm])))
  }

  let combine = fn(a, b) { dict.combine(a, b, list.append) }

  frontmatters
  |> list.map(partial)
  |> list.reduce(combine)
  |> result.unwrap(dict.new())
}

fn render_page(file: pipeline.MarkdownFile(Frontmatter), _tags: GroupedTags) {
  let fm = file |> pipeline.frontmatter

  html.html([], [
    html.body([], [
      html.h1([], [html.text(fm.title)]),
      html.main([], file |> pipeline.render_markdown),
    ]),
  ])
  |> Ok
}

fn render_index(tags: GroupedTags) {
  use path <- result.map(fs.site_path_from_string("/index.html"))

  html.html([], [
    html.body([], [
      html.h1([], [html.text(tags |> dict.keys |> string.join(" #"))]),
    ]),
  ])
  |> pipeline.create_html_file(path, _)
}

pub fn create_pipeline(content_dir: fs.DirPath) {
  let pipeline =
    pipeline.from_markdown(
      dir: content_dir,
      decode: frontmatter_decoder(),
      agg: group_by_tag,
      render: render_page,
    )
    |> pipeline.with(render_index)

  pipeline
}
