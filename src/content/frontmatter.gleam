import content/fs
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import yay

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
  let parse_result =
    yay.parse_string(frontmatter)
    |> result.replace_error("Frontmatter is not valid YAML:\n" <> frontmatter)

  use docs <- result.try(parse_result)
  case docs {
    [doc] -> decode(doc)
    [] -> Error("No YAML documents found in frontmatter")
    _ -> Error("Multiple YAML documents found in frontmatter")
  }
}

fn decode(doc: yay.Document) -> Result(Frontmatter, String) {
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
