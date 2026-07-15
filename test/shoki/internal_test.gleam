import birdie
import gleam/list
import gleam/string
import shoki/internal/fs
import shoki/internal/pipeline
import shoki/preset/default
import shoki/shoki

fn dir_to_string(dir) {
  let assert Ok(files) = fs.ls_dir(dir)

  files
  |> list.map(fs.file_path_to_string)
  |> list.sort(string.compare)
  |> string.join("\n")
}

pub fn ls_dir_test() {
  let assert Ok(dir) = fs.from_relative_dir("./test/workspace")

  dir_to_string(dir)
  |> birdie.snap("internal ls_dir")
}

pub fn default_pipeline_test() {
  let assert Ok(pages) = fs.from_relative_dir("./test/workspace/pages")
  let assert Ok(static) = fs.from_relative_dir("./test/workspace/static")

  let default_pipeline = default.create_pipeline(pages, static)
  let assert Ok(assets) = pipeline.run(default_pipeline)

  assets
  |> list.map(pipeline.asset_to_readable_string)
  |> string.join("\n\n")
  |> birdie.snap("workspace assets")
}

pub fn print_error_test() {
  let err =
    shoki.Collated([
      shoki.Context(
        "my/file1.md",
        shoki.Collated([
          shoki.Context("2021-1212", shoki.DateParseError("Invalid date")),
          shoki.ErrorReadingFrontmatter("Invalid frontmatter"),
        ]),
      ),
      shoki.Context(
        "my/file2.md",
        shoki.Collated([
          shoki.DirNotFound("/my/example/dir"),
        ]),
      ),
    ])

  err |> shoki.error_to_string |> birdie.snap("nested error formatting")
}
