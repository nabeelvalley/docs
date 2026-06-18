import consts
import content/fs
import content/md
import gleam/list
import gleam/result

pub type Book {
  Book(title: String, author: String, isbn: String)
}

pub type Collection {
  Collection(
    blog: List(md.MarkdownDocument),
    docs: List(md.MarkdownDocument),
    talks: List(md.MarkdownDocument),
  )
}

pub fn load_content() -> Result(Collection, String) {
  use blog <- result.try(load_markdown_content("blog"))
  use docs <- result.try(load_markdown_content("docs"))
  use talks <- result.try(load_markdown_content("talks"))

  Ok(Collection(blog:, docs:, talks:))
}

fn load_markdown_content(rel: String) {
  let rel_dir = fs.join([consts.content_dir, rel])
  use rel_files <- result.try(fs.load_content(rel_dir))
  Ok(result.values(list.map(rel_files, md.parse_markdown_file)))
}
