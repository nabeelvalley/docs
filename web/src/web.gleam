import consts
import content/content
import gleam/list
import gleam/result
import rendering/rendering
import simplifile

pub fn main() -> Result(Nil, String) {
  use content <- result.try(content.load_content())
  let pages = rendering.render(content)

  let deletion =
    simplifile.delete_all([consts.static_dir])
    |> result.replace_error("Error deleting static dir")

  use _ <- result.try(deletion)

  let written =
    pages
    |> list.try_each(fn(page) -> Result(Nil, String) {
      let path = consts.static_dir <> "/" <> page.slug <> ".html"

      simplifile.write(path, page.html)
      |> result.replace_error("Failed to write file: " <> path)
    })

  written |> echo
}
