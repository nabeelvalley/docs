import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import shoki/element
import shoki/internal/fs
import shoki/internal/markdown
import shoki/pipeline
import shoki/shoki.{type ShokiResult, ErrorReadingFrontmatter}
import yamleam

pub opaque type MarkdownFile(a) {
  MarkdownFile(
    path: fs.Path,
    site_path: fs.SitePath,
    frontmatter: a,
    content: String,
  )
}

fn read_file(
  dir: fs.Path,
  file: fs.Path,
  frontmatter_decoder,
) -> ShokiResult(MarkdownFile(a)) {
  use content <- result.try(fs.read_text_file(file))

  let lines = content |> string.trim |> string.split("\n")

  let not_end = fn(str) { !string.starts_with(str, "---") }
  let site_path = to_site_path(dir, file)
  let decode = frontmatter_decoder(site_path)

  case lines {
    ["---", ..rest] -> {
      let #(front, content) = list.split_while(rest, not_end)
      let fm = front |> string.join("\n")

      use frontmatter <- result.try(
        yamleam.parse(fm, decode)
        |> result.replace_error(
          ErrorReadingFrontmatter(fm)
          |> shoki.error_context(file |> fs.path_to_string),
        ),
      )

      Ok(MarkdownFile(
        file,
        site_path,
        frontmatter,
        content |> list.drop(1) |> string.join("\n"),
      ))
    }
    _ -> Error(ErrorReadingFrontmatter("No frontmatter present"))
  }
}

fn read_files(dir: fs.Path, decode_frontmatter) {
  use files <- result.try(fs.ls_dir(dir))

  files
  |> list.filter(fs.has_ext(_, [fs.MD, fs.MDX]))
  |> list.map(read_file(dir, _, decode_frontmatter))
  |> shoki.collate_errors
}

pub fn from_markdown(dir dir: fs.Path, decode decode, agg agg, render render) {
  pipeline.new(
    load: fn() {
      use pages <- result.map(read_files(dir, decode))

      pipeline.loaded(pages, pages |> list.map(frontmatter) |> agg)
    },
    render: fn(pages, agg) {
      pages
      |> list.map(fn(page) {
        render(page, agg) |> result.map(to_html_file(page, _))
      })
      |> shoki.collate_errors
    },
  )
}

pub fn frontmatter(file: MarkdownFile(a)) {
  file.frontmatter
}

fn exts() {
  dict.new()
  |> dict.insert(fs.MD, fs.HTML)
}

fn to_site_path(base: fs.Path, file: fs.Path) {
  fs.to_site_path(base, file, exts())
}

pub fn to_html_file(file: MarkdownFile(a), rendered: element.DocumentNode) {
  pipeline.HTMLFile(file.site_path, rendered)
}

pub fn render(file: MarkdownFile(a)) {
  file.content |> markdown.parse
}
