import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None}
import gleam/pair
import gleam/result
import gleam/string
import lustre/attribute
import lustre/element/html
import shoki/internal/date.{type IsoDate}
import shoki/internal/fs
import shoki/internal/pipeline
import shoki/internal/preset
import shoki/shoki

/// Basic frontmatter type for the default template
pub opaque type Frontmatter {
  Frontmatter(
    path: fs.SitePath,
    draft: Bool,
    title: String,
    description: Option(String),
    date: Option(IsoDate),
    tags: List(String),
  )
}

fn frontmatter_decoder(path: fs.SitePath) -> decode.Decoder(Frontmatter) {
  use draft <- decode.optional_field("draft", False, decode.bool)
  use title <- decode.field("title", decode.string)
  use description <- decode.field("description", decode.optional(decode.string))
  use date <- decode.optional_field("date", None, date.date_decoder())
  use tags <- decode.optional_field("tags", [], decode.list(decode.string))

  decode.success(Frontmatter(path:, draft:, title:, description:, date:, tags:))
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

fn header(title, tags: GroupedTags) {
  html.header([], [
    html.nav([], [
      html.ul(
        [],
        tags
          |> dict.keys
          |> list.map(fn(tag) {
            html.li([], [html.a([attribute.href("/" <> tag)], [html.text(tag)])])
          }),
      ),
    ]),
    html.h1([], [html.text(title)]),
  ])
}

fn item(entry: Frontmatter) {
  html.li([], [
    html.a([entry.path |> fs.site_path_to_href], [
      html.text(entry.title),
    ]),
  ])
}

fn index(path, title, tags, entries) {
  html.html([], [
    html.body([], [
      header(title, tags),
      html.main([], [html.ul([], entries |> list.map(item))]),
    ]),
  ])
  |> pipeline.create_html_file(path, _)
}

fn render_indices(tags: GroupedTags) {
  use path <- result.try(fs.site_path_from_string("/index.html"))

  let index_page =
    index(path, "Index", tags, tags |> dict.values |> list.flatten)

  let tags =
    tags
    |> dict.map_values(fn(tag, entries) {
      use path <- result.map(fs.site_path_from_string("/" <> tag <> ".html"))
      index(path, tag |> string.capitalise, tags, entries)
    })
    |> dict.values

  use tag_pages <- result.map(tags |> shoki.collate_errors)

  [index_page, ..tag_pages]
}

pub fn create_pipeline(content_dir: fs.DirPath) {
  let pipeline =
    pipeline.from_markdown(
      dir: content_dir,
      decode: frontmatter_decoder,
      agg: group_by_tag,
      render: render_page,
    )
    |> pipeline.with(render_indices)

  pipeline
}

pub fn main() {
  preset.run_main(create_pipeline)
}
