import gleam/list
import gleam/result
import web/consts
import web/fs
import web/md

pub type Book {
  Book(title: String, author: String, isbn: String)
}

pub type Collection {
  Collection(blog: List(md.MarkdownDocument), docs: List(md.MarkdownDocument))
}

pub fn load_content() -> Result(Collection, String) {
  let blog_dir = fs.join([consts.content_dir, "blog"])
  let docs_dir = fs.join([consts.content_dir, "docs"])

  use blog_files <- result.try(fs.load_content(blog_dir))
  use docs_files <- result.try(fs.load_content(docs_dir))

  let blog = result.values(list.map(blog_files, md.parse_markdown_file))
  let docs = result.values(list.map(docs_files, md.parse_markdown_file))

  Ok(Collection(blog:, docs:))
}
