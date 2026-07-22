import birdie
import gleam/list
import gleam/string
import mellie
import mellie/attr
import mellie/html
import shoki/component
import shoki/internal/fs
import shoki/markdown
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

  let assert Ok(assets) = default.create_pipeline(pages, static) |> pipeline.run

  assets
  |> pipeline.assets_to_readable_string
  |> birdie.snap("default pipeline assets")
}

pub fn pipeline_with_components_test() {
  let assert Ok(pages) = fs.from_cwd("./test/workspace/pages")
  let assert Ok(_static) = fs.from_cwd("./test/workspace/static")
  let assert Ok(custom_tag_page_path) =
    fs.site_path_from_string("/blog/second_post.html")

  let assert Ok(text_output_file_path) =
    fs.site_path_from_string("/blog/second_post_text.html")

  let components = [
    component.new("my-custom-tag", fn(el) {
      let text =
        el
        |> mellie.inner_text

      let data =
        text
        |> html.text
        |> pipeline.HTMLFile(text_output_file_path, _)

      let new_el =
        html.data(
          [
            attr.value(
              text
              |> string.replace("\n", " + "),
            ),
          ],
          [html.text("My Updated Tag")],
        )
      component.Visited(new_el, [data])
    }),
  ]

  let assert Ok(assets) =
    markdown.from_markdown(
      dir: pages,
      decode: default.frontmatter_decoder,
      agg: default.group_by_tag,
      render: default.render_page,
    )
    |> pipeline.with_components(components)
    |> pipeline.run

  let assert Ok(custom_tag_page) =
    assets |> pipeline.find_asset(custom_tag_page_path)

  let assert Ok(text_output_page) =
    assets |> pipeline.find_asset(text_output_file_path)

  [custom_tag_page, text_output_page]
  |> pipeline.assets_to_readable_string
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
