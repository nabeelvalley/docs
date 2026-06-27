import content/fs
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import js/marked
import yay

pub type MarkdownDocument {
  MarkdownDocument(path: String, frontmatter: Frontmatter, html: String)
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
  use #(front, md) <- result.try(separate_frontmatter(file))
  use frontmatter <- result.try(parse_frontmatter(front))

  let html = marked.parse(md)

  Ok(MarkdownDocument(file.relative, frontmatter:, html:))
}

fn separate_frontmatter(file: fs.File) -> Result(#(String, String), String) {
  let lines = file.content |> string.trim |> string.split("\n")

  let not_frontmatter_end = fn(str) { !string.starts_with(str, "---") }

  case lines {
    ["---", ..rest] -> {
      let #(front, content) = list.split_while(rest, not_frontmatter_end)

      Ok(#(
        front |> string.join("\n"),
        content |> list.drop(1) |> string.join("\n"),
      ))
    }
    _ -> Error("No frontmatter present:" <> file.path)
  }
}

fn parse_frontmatter(frontmatter: String) -> Result(Frontmatter, String) {
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
  use rss_only <- result.try(bool("rssOnly"))

  Ok(Frontmatter(title:, date:, description:, published:, feature:, rss_only:))
}
