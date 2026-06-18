import gleam/list
import gleam/option.{type Option}
import gleam/result
import mork
import mork/document
import web/consts
import web/fs

pub type Book {
  Book(title: String, author: String, isbn: String)
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

pub type MarkdownDocument {
  MarkdownDocument(frontmatter: Frontmatter, doc: document.Document)
}

pub type Collection {
  Collection(blog: List(document.Document), docs: List(document.Document))
}

pub fn load_content() {
  let blog_dir = fs.join([consts.content_dir, "blog"])
  use blog_files <- result.try(fs.load_content(blog_dir))
  let blog = list.map(blog_files, parse_markdown_file)

  let docs_dir = fs.join([consts.content_dir, "docs"])
  use docs_files <- result.try(fs.load_content(docs_dir))
  let docs = list.map(docs_files, parse_markdown_file)

  Collection(blog:, docs:)
  |> Ok
}

fn parse_markdown_file(file: fs.File) -> document.Document {
  file.content |> mork.parse
}
