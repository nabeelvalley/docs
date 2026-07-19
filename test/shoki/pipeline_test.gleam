import birdie
import gleam/list
import gleam/string
import shoki/component
import shoki/internal/fs
import shoki/pipeline
import shoki/preset/default
import shoki/shoki

fn dir_to_string(dir) {
  let assert Ok(files) = fs.ls_dir(dir)

  files
  |> list.map(fs.path_to_string)
  |> list.sort(string.compare)
  |> string.join("\n")
}

pub fn ls_dir_test() {
  let assert Ok(dir) = fs.from_cwd("./test/workspace")

  dir_to_string(dir)
  |> birdie.snap("internal ls_dir")
}

pub fn default_pipeline_test() {
  let assert Ok(pages) = fs.from_cwd("./test/workspace/pages")
  let assert Ok(static) = fs.from_cwd("./test/workspace/static")

  let pipeline = default.create_pipeline(pages, static)
  let assert Ok(assets) = pipeline.run(pipeline)

  assets
  |> pipeline.assets_to_readable_string
  |> birdie.snap("default pipeline assets")
}

pub fn pipeline_with_components_test() {
  let assert Ok(pages) = fs.from_cwd("./test/workspace/pages")
  let assert Ok(static) = fs.from_cwd("./test/workspace/static")
  let assert Ok(custom_tag_page_path) =
    fs.site_path_from_string("/blog/second_post.html")

  let components = [
    component.new("my-custom-tag", fn(x) { component.Visited(x, []) }),
  ]

  let pipeline =
    default.create_pipeline(pages, static)
    |> pipeline.with_components(components)

  let assert Ok(assets) = pipeline.run(pipeline)

  let assert Ok(custom_tag_page) =
    assets |> pipeline.find_asset(custom_tag_page_path)

  custom_tag_page
  |> pipeline.asset_to_readable_string
  |> birdie.snap("custom component assets")
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
