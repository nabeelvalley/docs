import argv
import clip
import clip/flag
import consts
import content/content
import content/fs
import gleam/io
import gleam/javascript/promise
import rendering/assets
import rendering/rendering
import util

pub fn main() {
  let cmd =
    clip.command({
      use clean <- clip.parameter
      // to be used for running axe linting once pages are rendered
      use report <- clip.parameter

      use processing <- promise.await({
        // load
        use content <- util.try_resolve(content.load_content())

        use pages <- util.try_resolve(rendering.render(content))

        use _ <- util.try_resolve(case clean {
          False -> Ok(Nil)
          True -> fs.delete(consts.out_dir)
        })

        // write
        use _ <- util.try_resolve(fs.copy_dir(consts.public_dir, consts.out_dir))

        use result <- promise.await(assets.write_pages(pages))
        result |> promise.resolve
      })

      case processing {
        Ok(_) -> io.println("Wrote output to " <> consts.out_dir)
        Error(e) -> io.println_error(e)
      }
      |> promise.resolve
    })
    |> clip.flag(flag.new("clean") |> flag.help("clean out dir"))
    |> clip.flag(
      flag.new("report") |> flag.help("run a11y and link-checking reports"),
    )

  cmd |> clip.run(argv.load().arguments)
}
