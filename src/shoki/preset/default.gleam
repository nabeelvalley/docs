import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/pair
import gleam/result
import gleam/string
import mellie/attr
import mellie/html
import shoki
import shoki/date.{type IsoDate}
import shoki/error
import shoki/image
import shoki/internal/fs
import shoki/internal/preset
import shoki/markdown
import shoki/preset/shared

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

pub fn frontmatter_decoder(path: fs.SitePath) -> decode.Decoder(Frontmatter) {
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

const css_path = "/default.css"

pub fn render_page(
  file: markdown.MarkdownFile(Frontmatter),
  tags: GroupedTags,
) {
  let content = file |> markdown.content
  let fm = file |> markdown.frontmatter

  html.body([], [
    header(fm.title, tags),
    html.main([], [content]),
  ])
  |> shared.page(fm.title, css_path)
  |> Ok
}

fn header(title, tags: GroupedTags) {
  html.header([], [
    html.h1([], [html.text(title)]),
    html.nav([], [
      html.ul(
        [],
        tags
          |> dict.keys
          |> list.map(fn(tag) {
            html.li([], [html.a([attr.href("/" <> tag)], [html.text(tag)])])
          }),
      ),
    ]),
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
  html.body([], [
    header(title, tags),
    html.main([], [html.ul([], entries |> list.map(item))]),
  ])
  |> shared.page(title, css_path)
  |> shoki.generated_html_file(path, _)
}

fn tag_pages(tags: GroupedTags) {
  tags
  |> dict.map_values(fn(tag, entries) {
    use path <- result.map(fs.site_path_from_string("/" <> tag <> ".html"))
    index(path, tag |> string.capitalise, tags, entries)
  })
  |> dict.values
  |> error.collate_errors
}

pub fn compare_date(a: Frontmatter, b: Frontmatter) {
  case a.date, b.date {
    Some(a), Some(b) -> date.compare(a, b)
    Some(_), _ -> order.Gt
    None, _ -> order.Lt
  }
}

fn index_page(tags: GroupedTags) {
  use path <- result.try(fs.site_path_from_string("/index.html"))

  index(
    path,
    "Index",
    tags,
    tags
      |> dict.values
      |> list.flatten
      |> list.unique
      |> list.sort(compare_date),
  )
  |> Ok
}

pub fn create_pipeline(
  out_dir: fs.Path,
  content_dir: fs.Path,
  static_dir: fs.Path,
) {
  let pipeline =
    markdown.from_markdown(
      out: out_dir,
      dir: content_dir,
      decode: frontmatter_decoder,
      agg: group_by_tag,
      render: render_page,
    )
    |> shoki.with_assets(tag_pages)
    |> shoki.with_asset(index_page)
    |> shoki.with_static_dir(static_dir)
    |> image.with_image_optimization(static_dir)

  pipeline
}

pub fn main() {
  preset.run_main(create_pipeline)
}
