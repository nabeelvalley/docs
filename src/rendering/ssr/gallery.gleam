import consts
import content/fs
import gleam/dict
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option
import gleam/result
import js/dom
import js/sharp
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}
import rendering/ssr/custom_el
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

pub fn render_all(page: Page) -> Promise(Result(Page, String)) {
  let tree = dom.get_nodes(page.html, tag: "gallery")
  use galleries <- util.try_resolve(
    tree.nodes
    |> list.map(read_gallery_node)
    |> result.all,
  )

  use updates <- promise.try_await(
    galleries
    |> list.map(fn(gallery) {
      render(gallery.images)
      |> promise.map(fn(el) {
        el
        |> result.map(element.to_string)
        |> result.map(dom.NodeUpdate(gallery.node, _))
      })
    })
    |> promise.await_list
    |> promise.map(result.all),
  )

  let html = dom.update_nodes(tree.root, updates)
  let assets = galleries |> list.flat_map(fn(g) { g.images })

  Ok(Page(..page, html:, assets: list.append(page.assets, assets)))
  |> promise.resolve
}

fn render(
  paths: List(assets.Asset),
) -> Promise(Result(element.Element(a), String)) {
  use content: List(element.Element(a)) <- promise.try_await(
    paths
    |> list.map(render_image)
    |> promise.await_list
    |> promise.map(result.all),
  )

  Ok(custom_el.site_gallery(content)) |> promise.resolve
}

fn render_image(
  img: assets.Asset,
) -> Promise(Result(element.Element(a), String)) {
  use resolved <- util.try_resolve(assets.resolve(img))
  use meta <- promise.try_await(sharp.meta(img.input_file))

  Ok(custom_el.site_gallery_image(
    meta,
    html.img([
      attribute.src(resolved.site_path),
      attribute.alt(
        fs.file_name_only(img.input_file)
        |> option.unwrap(""),
      ),
    ]),
  ))
  |> promise.resolve
}
