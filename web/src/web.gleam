import consts
import content/content
import content/fs
import gleam/io
import gleam/javascript/promise.{type Promise}
import rendering/assets
import rendering/rendering
import util

pub fn main() -> Promise(Nil) {
  use process <- promise.await({
    use content <- util.try_resolve(content.load_content())

    use _ <- util.try_resolve(fs.copy_dir(consts.public_dir, consts.out_dir))

    use pages <- util.try_resolve(rendering.render(content))

    use _ <- util.try_resolve(fs.delete(consts.out_dir))
    use result <- promise.await(assets.write_pages(pages))

    result |> promise.resolve
  })

  case process {
    Ok(_) -> io.println("Wrote output to " <> consts.out_dir)
    Error(e) -> io.println_error(e)
  }

  promise.resolve(Nil)
}
