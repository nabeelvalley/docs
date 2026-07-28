import gleam/dict
import gleam/dynamic/decode
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import mellie
import presentable_soup
import shoki/error.{type ShokiResult, ErrorReadingFrontmatter}
import shoki/internal/fs
import shoki/internal/markdown
import shoki/pipeline
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
          |> error.error_context(file |> fs.path_to_string),
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
  |> error.collate_errors
}

pub fn from_markdown(
  dir dir: fs.Path,
  decode decode: fn(fs.SitePath) -> decode.Decoder(a),
  agg agg: fn(List(a)) -> b,
  render render: fn(MarkdownFile(a), b) ->
    Result(presentable_soup.ElementTree, error.ShokiErr),
) -> pipeline.Pipeline(MarkdownFile(a), b) {
  pipeline.new(
    load: fn() {
      use pages <- result.map(read_files(dir, decode))

      pipeline.loaded(pages, pages |> list.map(frontmatter) |> agg)
    },
    render: fn(pages: List(MarkdownFile(a)), agg: b) -> Result(
      pipeline.Rendered,
      error.ShokiErr,
    ) {
      pages
      |> list.map(fn(page) {
        use rendered <- result.map(render(page, agg))

        rendered
        |> to_html_file(page, _)
      })
      |> error.collate_errors
      |> result.map(pipeline.from_assets)
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

pub fn to_html_file(file: MarkdownFile(a), rendered: mellie.ElementTree) {
  pipeline.HTMLFile(option.Some(file.path), file.site_path, rendered)
}

pub fn replace_body(tree: mellie.ElementTree) {
  tree
  |> mellie.get_child_by_tag("body")
  |> result.replace_error(error.ErrorRenderingMarkdown(
    "Failed to find body in rendered markdown",
  ))
  |> result.map(mellie.children)
  |> result.map(mellie.element("div", [], _))
}

pub fn render(file: MarkdownFile(a)) -> ShokiResult(mellie.ElementTree) {
  file.content
  |> markdown.parse
  |> mellie.parse
  |> result.replace_error(error.ErrorRenderingMarkdown(
    "Error parsing HTML from markdown",
  ))
  |> result.try(replace_body)
}
