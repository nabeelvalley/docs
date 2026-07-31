import birdie
import gleam/dict
import gleam/javascript/promise
import gleam/list
import gleam/result
import gleam/string
import mellie
import mellie/attr
import mellie/html
import shoki
import shoki/component
import shoki/error
import shoki/image
import shoki/internal/fs
import shoki/markdown
import shoki/preset/default

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
  use rendered <- promise.await(pipeline |> shoki.run)

  let assert Ok(assets) = rendered

  assets
  |> shoki.assets_to_readable_string
  |> birdie.snap("default pipeline assets")
  |> promise.resolve
}

pub fn pipeline_with_components_test() {
  let assert Ok(pages) = fs.from_cwd("./test/workspace/pages")
  let assert Ok(static) = fs.from_cwd("./test/workspace/static")
  let assert Ok(custom_tag_page_path) =
    fs.site_path_from_string("/blog/second_post.html")

  let assert Ok(text_output_file_path) =
    fs.site_path_from_string("/blog/second_post_text.html")

  let with_my_custom_tag_extractor = shoki.with_derived_assets(_, fn(a) {
    use file <- shoki.if_html(a, Ok([]))

    let children = mellie.get_children_by_tag(file.html, "my-custom-tag")
    list.map(children, fn(child) {
      let text = child |> mellie.inner_text

      text
      |> html.text
      |> shoki.generated_html_file(text_output_file_path, _)
    })
    |> Ok
  })

  let with_my_async_tag_updater = shoki.with_task(_, fn(a) {
    use file <- shoki.if_html(a, Ok([]))

    let children = mellie.get_children_by_tag(file.html, "my-async-tag")
    list.map(children, fn(child) {
      let text =
        child
        |> mellie.attrs
        |> dict.from_list
        |> dict.get("data")
        |> result.unwrap("data not found")
        |> mellie.text

      let new_el =
        mellie.element("my-updated-async-tag", child |> mellie.attrs, [
          mellie.text("Extracted text: "),
          text,
        ])

      shoki.html_file_transform_task(file.path, child, fn() {
        new_el |> Ok |> promise.resolve
      })
    })
    |> Ok
  })

  let my_custom_tag =
    component.new("my-custom-tag", fn(_, el) {
      let text =
        el
        |> mellie.inner_text

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

      new_el
    })

  let pipeline =
    markdown.from_markdown(
      dir: pages,
      decode: default.frontmatter_decoder,
      agg: default.group_by_tag,
      render: default.render_page,
    )
    // extracts custom tag before rendering
    |> with_my_custom_tag_extractor
    // creates task from async tag
    |> with_my_async_tag_updater
    // renders custom tag before rendering
    |> shoki.with_components([my_custom_tag])
    |> image.with_image_optimization(static)

  use rendered <- promise.await(pipeline |> shoki.run)
  let assert Ok(assets) = rendered

  let assert Ok(custom_tag_page) =
    assets |> shoki.find_asset(custom_tag_page_path)

  let assert Ok(text_output_page) =
    assets |> shoki.find_asset(text_output_file_path)

  [custom_tag_page, text_output_page]
  |> shoki.assets_to_readable_string
  |> birdie.snap("custom component assets")
  |> promise.resolve
}

pub fn print_error_test() {
  let err =
    error.Collated([
      error.Context(
        "my/file1.md",
        error.Collated([
          error.Context("2021-1212", error.DateParseError("Invalid date")),
          error.ErrorReadingFrontmatter("Invalid frontmatter"),
        ]),
      ),
      error.Context(
        "my/file2.md",
        error.Collated([
          error.DirNotFound("/my/example/dir"),
        ]),
      ),
    ])

  err |> error.error_to_string |> birdie.snap("nested error formatting")
}
