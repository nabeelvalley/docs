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
      use dir <- clip.parameter
      use out <- clip.parameter

      let assert Ok(dir) = fs.from_relative_dir(dir)
      let assert Ok(out) = fs.ensure_relative_dir(out)

      let assert Ok(_) =
        create_pipeline(dir)
        |> pipeline.run()
        |> result.try(pipeline.write_all(out, _))
        |> result.map_error(shoki.error_to_string)
    })
    |> clip.opt(opt.new("dir") |> opt.help("directory to load pages from"))
    |> clip.opt(opt.new("out") |> opt.help("directory to save to"))
    |> clip.help(help.simple(
      "Shoki Default Template",
      "Use --dir to provide a directory with pages",
    ))

  let result = cmd |> clip.run(argv.load().arguments)
  case result {
    Error(err) -> io.println_error(err)
    _ -> io.println("Pipeline run successfully")
  }
}
