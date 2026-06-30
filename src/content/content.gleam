import consts
import content/frontmatter.{type Frontmatter}
import content/fs
import gleam/io
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import js/marked
import util

pub type Book {
  Book(title: String, author: String, isbn: String)
}

pub type Page {
  Page(path: String, slug: String, frontmatter: Frontmatter, html: String)
}

pub type Collection {
  Collection(pages: List(Page))
}

pub fn load_content() -> Result(Collection, String) {
  use content <- result.try(fs.load_content(consts.content_dir))

  let md_files = content |> list.filter(fs.is_markdown)
  let html_files = content |> list.filter(fs.is_html)

  use md_pages <- util.try_all_merge_errors(md_files |> list.map(read_markdown))
  use html_pages <- util.try_all_merge_errors(html_files |> list.map(read_html))

  let pages = md_pages |> list.append(html_pages)

  Ok(Collection(pages:))
}

fn read_markdown(file: fs.File) {
  use extracted <- result.try(frontmatter.extract(file))
  let html = marked.parse(extracted.content)

  io.println("loaded page: " <> file.path)

  Ok(Page(file.path, to_slug(file.path), extracted.frontmatter, html))
}

fn read_html(file: fs.File) {
  use extracted <- result.try(frontmatter.extract(file))

  io.println("loaded page: " <> file.path)

  Ok(Page(
    file.path,
    to_slug(file.path),
    extracted.frontmatter,
    extracted.content,
  ))
}

fn to_slug(rel: String) {
  let assert Ok(re) = regexp.from_string("\\.\\w+$")
  // echo rel
  rel |> string.replace(consts.content_dir_rel, "") |> regexp.replace(re, _, "")
}
