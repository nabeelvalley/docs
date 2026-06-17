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
  let docs_dir = fs.join([consts.content_dir, "docs"])

  fs.load_content(consts.content_dir)
  |> result.map(list.filter(_, fs.is_markdown))
  |> result.map(fn(files) {
    let is_blog = fs.is_child(_, blog_dir)
    let is_docs = fs.is_child(_, docs_dir)

    echo files
    Collection(
      blog: files
        |> list.filter(is_blog)
        |> list.map(parse_markdown_file),
      docs: files
        |> list.filter(is_docs)
        |> list.map(parse_markdown_file),
    )
  })
}

fn parse_markdown_file(file: fs.File) -> document.Document {
  file.content |> mork.parse
}
