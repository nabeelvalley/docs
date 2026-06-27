import consts
import content/content
import content/fs
import gleam/io
import gleam/javascript/promise
import rendering/assets
import rendering/rendering
import util

pub fn main() {
  // load
  use content <- util.try_resolve(content.load_content())

  use pages <- util.try_resolve(rendering.render(content))

  // write
  use _ <- util.try_resolve(fs.delete(consts.out_dir))

  use _ <- util.try_resolve(fs.copy_dir(consts.public_dir, consts.out_dir))

  use result <- promise.await(assets.write_pages(pages))

  case result {
    Ok(_) -> io.println("Wrote output to " <> consts.out_dir)
    Error(e) -> io.println_error(e)
  }

  result |> promise.resolve
}
