import consts
import content/content
import content/fs
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/list
import rendering/rendering

pub fn main() -> Promise(Result(Nil, String)) {
  // delete contents since rendering might output artifacts
  // that may also be written to disc
  use _ <- promise.try_await(fs.delete(consts.out_dir) |> promise.resolve)
  use content <- promise.try_await(content.load_content() |> promise.resolve)

  io.println("Loaded content")

  use _ <- promise.try_await(
    fs.copy_dir(consts.public_dir, consts.out_dir) |> promise.resolve,
  )

  use pages <- promise.await(rendering.render(content))

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

  promise.resolve(result)
}
