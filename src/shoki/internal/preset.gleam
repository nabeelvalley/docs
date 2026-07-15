import argv
import clip
import clip/help
import clip/opt
import gleam/io
import gleam/result
import shoki/internal/fs
import shoki/internal/pipeline
import shoki/shoki

pub fn run_main(create_pipeline) {
  let cmd =
    clip.command({
      use pages <- clip.parameter
      use static <- clip.parameter
      use out <- clip.parameter

      use pages <- result.try(fs.from_relative_dir(pages))
      use static <- result.try(fs.from_relative_dir(static))
      use out <- result.try(fs.ensure_relative_dir(out))

      let pipeline = create_pipeline(pages, static)
      use assets <- result.try(
        pipeline
        |> pipeline.run(),
      )

      pipeline.write_all(out, assets)
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
    Error(err) -> io.println_error(err)
    Ok(cmd_result) -> {
      case cmd_result {
        Ok(_) -> io.println("Pipeline run successfully")
        Error(err) -> io.println_error(err |> shoki.error_to_string)
      }
    }
  }
}
