import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/pair
import gleam/result
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}

pub fn render_all(page: Page) -> Result(Page, String) {
  let #(root, nodes) = dom.get_nodes(page.html, tag: "gallery")
  let galleries =
    nodes
    |> list.map(fn(node) {
      let attrs = dict.from_list(node.attrs)
      use path <- result.try(
        dict.get(attrs, "path")
        |> result.replace_error("could not read path for snippet"),
      )

      let gallery_path = fs.join([consts.gallery_dir, path])

      use files <- result.try(fs.ls_dir(gallery_path))

      let images =
        files
        |> list.map(fn(f) { assets.OptimizeImageAsset(f.path) })

      Ok(#(node, images))
    })

  use gs <- result.try(galleries |> result.all)

  let update_results =
    gs
    |> list.map(fn(gallery) {
      let #(node, images) = gallery

      render(images)
      |> element.to_document_string
      |> dom.NodeUpdate(node.node, _)
      |> Ok
    })
    |> result.all

  use updates <- result.try(update_results)
  let html = dom.update_nodes(root, updates)
  let assets = gs |> list.map(pair.second) |> list.flatten

  Ok(Page(..page, html:, assets:))
}

fn render(paths: List(assets.Asset)) {
  paths
  |> list.map(fn(img) {
    html.img([attribute.src(assets.resolve(img).site_path)])
  })
  |> html.div([], _)
}
