import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import mork
import mork/document
import web/fs
import yay

pub type MarkdownDocument {
  MarkdownDocument(
    path: String,
    frontmatter: Frontmatter,
    doc: document.Document,
  )
}

pub type Frontmatter {
  Frontmatter(
    title: Option(String),
    date: Option(String),
    description: Option(String),
    published: Bool,
    feature: Bool,
    rss_only: Bool,
  )
}

pub fn parse_markdown_file(file: fs.File) -> Result(MarkdownDocument, String) {
  let doc = mork.parse(file.content)
  use frontmatter <- result.try(parse_frontmatter(file))

  Ok(MarkdownDocument(file.path, frontmatter:, doc:))
}

fn parse_frontmatter(file: fs.File) -> Result(Frontmatter, String) {
  let lines = string.split(file.content, "\n") |> list.map(string.trim)
  let not_frontmatter_end = fn(str) { !string.starts_with(str, "---") }

  use frontmatter <- result.try(case lines {
    ["---", ..rest] ->
      list.take_while(rest, not_frontmatter_end) |> string.join("\n") |> Ok
    _ -> Error("No frontmatter present:" <> file.path)
  })

  let parse_result =
    yay.parse_string(frontmatter)
    |> result.replace_error("Frontmatter is not valid YAML:\n" <> frontmatter)

  use docs <- result.try(parse_result)
  case docs {
    [doc] -> decode_frontmatter(doc)
    [] -> Error("No YAML documents found in frontmatter")
    _ -> Error("Multiple YAML documents found in frontmatter")
  }
}

fn decode_frontmatter(doc: yay.Document) -> Result(Frontmatter, String) {
  let str = fn(field) {
    yay.extract_optional_string(doc.root, field)
    |> result.replace_error("Error parsing frontmatter property: " <> field)
  }

  let bool = fn(field) {
    yay.extract_bool_or(doc.root, field, False)
    |> result.replace_error("Error parsing frontmatter property: " <> field)
  }

  use title <- result.try(str("title"))
  use date <- result.try(str("date"))
  use description <- result.try(str("description"))

  use published <- result.try(bool("published"))
  use feature <- result.try(bool("feature"))
  use rss_only <- result.try(bool("rss_only"))

  Ok(Frontmatter(title:, date:, description:, published:, feature:, rss_only:))
}
