import consts
import content/content
import content/fs
import gleam/io
import gleam/list
import gleam/result
import rendering/rendering
import simplifile

pub fn main() -> Result(Nil, String) {
  use content <- result.try(content.load_content())
  io.println("Loaded content")

  let pages = rendering.render(content)

  let deletion =
    simplifile.delete_all([consts.static_dir])
    |> result.replace_error("Error deleting static dir")

  use _ <- result.try(deletion)

  let result =
    pages
    |> list.try_each(fn(page) -> Result(Nil, String) {
      let path = consts.static_dir <> "/" <> page.slug <> ".html"
      let dir = fs.parent(path)

      use _ <- result.try(
        simplifile.create_directory_all(dir)
        |> result.replace_error("Failed to create dir: " <> dir),
      )

      simplifile.write(path, page.html)
      |> result.replace_error("Failed to write file: " <> path)
    })

  case result {
    Ok(_) -> io.println("Wrote output to " <> consts.static_dir)
    Error(e) -> io.println_error(e)
  }

  result
}
