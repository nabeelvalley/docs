import birdie
import gleam/dict
import gleam/javascript/promise
import gleam/list
import gleam/result
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

  let pipeline = default.create_pipeline(pages, static)
  use rendered <- promise.await(pipeline |> pipeline.run)

  let assert Ok(assets) = rendered

  assets
  |> pipeline.assets_to_readable_string
  |> birdie.snap("default pipeline assets")
  |> promise.resolve
}

pub fn pipeline_with_components_test() {
  let assert Ok(pages) = fs.from_cwd("./test/workspace/pages")
  let assert Ok(_static) = fs.from_cwd("./test/workspace/static")
  let assert Ok(custom_tag_page_path) =
    fs.site_path_from_string("/blog/second_post.html")

  let assert Ok(text_output_file_path) =
    fs.site_path_from_string("/blog/second_post_text.html")

  let my_custom_tag_extractor =
    pipeline.extract_assets(fn(a) {
      case a {
        pipeline.HTMLFile(source: _, path: _, html:) -> {
          let children = mellie.get_children_by_tag(html, "my-custom-tag")
          list.map(children, fn(child) {
            let text = child |> mellie.inner_text

            text
            |> html.text
            |> pipeline.html_file_without_source(text_output_file_path, _)
          })
        }
        _ -> []
      }
      |> Ok
    })

  let my_async_tag_updater =
    pipeline.create_task(fn(a) {
      case a {
        pipeline.HTMLFile(source: _, path:, html:) -> {
          let children = mellie.get_children_by_tag(html, "my-async-tag")
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

            pipeline.HTMLFileTransformTask(
              path,
              pipeline.Replacement(child),
              fn() { new_el |> Ok |> promise.resolve },
            )
          })
        }
        _ -> []
      }
      |> Ok
    })

  let my_custom_tag =
    component.new("my-custom-tag", fn(el) {
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
    |> pipeline.with_additional_assets(my_custom_tag_extractor)
    // renders custom tag before rendering
    |> pipeline.with_components([my_custom_tag])
    // creates taks from async tag
    |> pipeline.with_task(my_async_tag_updater)

  use rendered <- promise.await(pipeline |> pipeline.run)
  let assert Ok(assets) = rendered

  let assert Ok(custom_tag_page) =
    assets |> pipeline.find_asset(custom_tag_page_path)

  let assert Ok(text_output_page) =
    assets |> pipeline.find_asset(text_output_file_path)

  [custom_tag_page, text_output_page]
  |> pipeline.assets_to_readable_string
  |> birdie.snap("custom component assets")
  |> promise.resolve
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
