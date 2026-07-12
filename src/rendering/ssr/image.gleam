import consts
import content/fs
import gleam/dict
import gleam/float
import gleam/javascript/promise
import gleam/list
import gleam/option
import gleam/result
import gleam/uri
import js/dom
import js/sharp
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}
import util

pub fn render_all(page: Page) -> promise.Promise(Result(Page, String)) {
  let tree = dom.get_nodes(page.html, tag: "img")
  use images <- util.try_resolve(
    tree.nodes
    |> list.map(read_image_node(_, page))
    |> result.all,
  )

  use updates <- promise.try_await(
    images
    |> list.map(fn(i) {
      case i {
        RemoteImageNode(_) -> option.None |> promise.resolve
        LocalImageNode(node:, asset:) -> {
          // don't touch files that we can't optimize
          case sharp.can_optimize(asset.input_file) {
            False -> option.None |> promise.resolve
            True -> {
              use result <- promise.await(render_image(node, asset))

              option.Some(
                result
                |> result.map(element.to_string)
                |> result.map(dom.NodeUpdate(node.node, _)),
              )
              |> promise.resolve
            }
          }
        }
      }
    })
    |> promise.await_list
    |> promise.map(option.values)
    |> promise.map(result.all),
  )

  let html = dom.update_nodes(tree.root, updates)
  let assets = images |> list.map(asset) |> option.values

  Page(..page, html:, assets: list.append(page.assets, assets))
  |> Ok
  |> promise.resolve
}

fn asset(node: ImageNode) {
  case node {
    LocalImageNode(_, asset:) -> option.Some(asset)
    RemoteImageNode(_) -> option.None
  }
}

type ImageNode {
  LocalImageNode(node: dom.Node, asset: assets.Asset)
  RemoteImageNode(node: dom.Node)
}

fn read_image_node(node: dom.Node, page: Page) -> Result(ImageNode, String) {
  let attrs = dict.from_list(node.attrs)
  use src <- result.try(
    dict.get(attrs, "src")
    |> result.replace_error("could not read img src"),
  )

  resolve(node, page.path, src)
}

fn resolve(node, from_file: String, path: String) {
  case path {
    "https://" <> _ -> {
      Ok(RemoteImageNode(node))
    }
    "http://" <> _ -> {
      Ok(RemoteImageNode(node))
    }
    "/" <> public_path ->
      fs.join([consts.public_dir, public_path])
      |> result.try(from_uri_path)
      |> result.map(assets.OptimizeImageAsset)
      |> result.map(LocalImageNode(node, _))
    _ -> {
      fs.parent(from_file)
      |> result.try(fn(parent) { fs.join([parent, path]) })
      |> result.try(from_uri_path)
      |> result.map(assets.OptimizeImageAsset)
      |> result.map(LocalImageNode(node, _))
    }
  }
}

fn from_uri_path(str) {
  uri.percent_decode(str)
  |> result.replace_error("Invalid URI: " <> str)
}

fn render_image(
  node: dom.Node,
  asset: assets.Asset,
) -> promise.Promise(Result(element.Element(a), String)) {
  use meta <- promise.try_await(sharp.meta(asset.input_file))
  use resolved <- util.try_resolve(assets.resolve(asset))
  let attrs =
    node.attrs
    |> list.map(fn(attr) {
      let #(k, v) = attr
      attribute.attribute(k, v)
    })

  let aspect_ratio =
    meta
    |> sharp.aspect_ratio
    |> float.to_string
    |> attribute.attribute("aspect-ratio", _)

  let alt =
    node.attrs |> dict.from_list |> dict.get("alt") |> option.from_result

  let src = attribute.src(resolved.site_path)
  let alt =
    attribute.alt(
      alt
      |> option.or(fs.file_name_only(resolved.input_file))
      |> option.unwrap(""),
    )

  Ok(html.img(attrs |> list.append([src, alt, aspect_ratio])))
  |> promise.resolve
}
