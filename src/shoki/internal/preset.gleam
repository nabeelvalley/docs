import argv
import clip
import clip/help
import clip/opt
import gleam/io
import gleam/javascript/promise
import shoki/async
import shoki/error
import shoki/internal/fs
import shoki

pub fn run_main(create_pipeline) {
  let cmd =
    clip.command({
      use pages <- clip.parameter
      use static <- clip.parameter
      use out <- clip.parameter

      use pages <- async.try_resolve(fs.from_cwd(pages))
      use static <- async.try_resolve(fs.from_cwd(static))
      use out <- async.try_resolve(fs.ensure_relative_dir(out))

      let pipeline = create_pipeline(pages, static)
      use assets <- promise.try_await(
        pipeline
        |> shoki.run(),
      )

      shoki.write_all(out, assets) |> promise.resolve
    })
    |> clip.opt(opt.new("pages") |> opt.help("directory to load pages from"))
    |> clip.opt(
      opt.new("static") |> opt.help("directory with static content to copy"),
    )
    |> clip.opt(opt.new("out") |> opt.help("directory to save to"))
    |> clip.help(help.simple(
      "Shoki Default Template",
      "Use --dir to provide a directory with pages",
    ))

  let result = cmd |> clip.run(argv.load().arguments)
  case result {
    Error(err) -> io.println_error(err) |> promise.resolve
    Ok(cmd_result) -> {
      use cmd_resolved <- promise.await(cmd_result)
      case cmd_resolved {
        Ok(_) -> io.println("Pipeline run successfully")
        Error(err) -> io.println_error(err |> error.error_to_string)
      }
      |> promise.resolve
    }
  }
}
