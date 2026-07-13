import gleam/list
import gleam/result
import gleam/string
import shoki/internal/fs.{type DirPath}
import shoki/shoki.{type ShokiResult, ErrorReadingFrontmatter}
import yamleam

type Loader(a) =
  fn() -> ShokiResult(List(a))

/// load -> process -> persist
pub opaque type Pipeline(a, b) {
  Pipeline(
    /// Loads all data in so that any non-render output
    /// can be shared with other pages and pipelines
    load: Loader(a),
    /// Process a single page - receives all loaded data
    render: fn(a, List(a)) -> ShokiResult(b),
    /// Persist a single page along with any necessary items
    persist: fn(b) -> ShokiResult(Nil),
    /// Any other pipelines this one depends on
    /// Will need to be executed by the runner prior to itself
    depends_on: List(Loader(a)),
  )
}

pub opaque type MarkdownFile(a) {
  MarkdownFile(frontmatter: a, content: String)
}

fn read_markdown_file(
  file: fs.FilePath,
  decode_frontmatter,
) -> ShokiResult(MarkdownFile(a)) {
  use content <- result.try(fs.read_text_file(file))

  let lines = content |> string.trim |> string.split("\n")

  let not_end = fn(str) { !string.starts_with(str, "---") }

  case lines {
    ["---", ..rest] -> {
      let #(front, content) = list.split_while(rest, not_end)
      use frontmatter <- result.try(
        yamleam.parse(front |> string.join("\n"), decode_frontmatter)
        |> result.replace_error(ErrorReadingFrontmatter(
          "Error parsing frontmatter",
        )),
      )

      Ok(MarkdownFile(frontmatter, content |> list.drop(1) |> string.join("\n")))
    }
    _ -> Error(ErrorReadingFrontmatter("No frontmatter present"))
  }
}

fn read_markdown_files(dir: DirPath, decode_frontmatter) {
  use files <- result.try(fs.ls_dir(dir))

  files
  |> list.filter(fs.has_ext(_, [fs.MD, fs.MDX]))
  |> list.map(read_markdown_file(_, decode_frontmatter))
  |> result.all
}

pub fn from_markdown(dir: DirPath, decode_frontmatter, render) {
  Pipeline(
    load: fn() { read_markdown_files(dir, decode_frontmatter) },
    render: fn(_, _) { todo },
    persist: fn(_) { todo },
    depends_on: [],
  )
}
