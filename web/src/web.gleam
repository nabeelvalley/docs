import consts
import content/content
import content/fs
import gleam/io
import gleam/list
import gleam/result
import rendering/rendering

pub fn main() -> Result(Nil, String) {
  use content <- result.try(content.load_content())
  io.println("Loaded content")

  let pages = rendering.render(content)

  use _ <- result.try(fs.delete(consts.out_dir))

  let result =
    pages
    |> list.try_each(fn(page) -> Result(Nil, String) {
      let path = consts.out_dir <> "/" <> page.slug <> ".html"
      fs.write(path, page.html)
    })

  case result {
    Ok(_) -> io.println("Wrote output to " <> consts.out_dir)
    Error(e) -> io.println_error(e)
  }

  result
}
