import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}
import util

type GalleryNode {
  GalleryNode(node: dom.JSNodeRef, images: List(assets.Asset))
}

fn read_gallery_node(node: dom.Node) -> Result(GalleryNode, String) {
  let attrs = dict.from_list(node.attrs)
  use path <- result.try(
    dict.get(attrs, "path")
    |> result.replace_error("could not read path for snippet"),
  )

  use gallery_path <- result.try(fs.join([consts.gallery_dir, path]))

  use files <- result.try(fs.ls_dir(gallery_path))

  let images =
    files
    |> list.map(fn(f) { assets.OptimizeImageAsset(f.path) })

  Ok(GalleryNode(node.node, images))
}

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "gallery")
  use galleries <- util.try_list(
    tree.nodes
    |> list.map(read_gallery_node),
  )

  use updates <- result.try(
    galleries
    |> list.try_map(fn(gallery) {
      render(gallery.images)
      |> result.map(element.to_string)
      |> result.map(dom.NodeUpdate(gallery.node, _))
    }),
  )

  let html = dom.update_nodes(tree.root, updates)
  let assets = galleries |> list.flat_map(fn(g) { g.images })

  Ok(Page(..page, html:, assets: list.append(page.assets, assets)))
}

fn render(paths: List(assets.Asset)) {
  use content <- result.try(
    paths
    |> list.try_map(fn(img) {
      use resolved <- result.try(assets.resolve(img))
      Ok(
        html.img([
          attribute.src(resolved.site_path),
          attribute.alt(
            fs.file_name_only(img.input_file)
            |> option.unwrap(""),
          ),
        ]),
      )
    }),
  )

  Ok(html.div([], content))
}
