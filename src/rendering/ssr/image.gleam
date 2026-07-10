import consts
import content/fs
import gleam/dict
import gleam/list
import gleam/option
import gleam/result
import gleam/uri
import js/dom
import lustre/attribute
import lustre/element
import lustre/element/html
import rendering/assets.{type Page, Page}

pub fn render_all(page: Page) -> Result(Page, String) {
  let tree = dom.get_nodes(page.html, tag: "img")
  use images <- result.try(
    tree.nodes
    |> list.map(read_image_node(_, page))
    |> result.all,
  )

  use updates <- result.map(
    images
    |> list.map(fn(i) {
      case i {
        LocalImageNode(node:, asset:) ->
          option.Some(
            render_image(asset)
            |> result.map(element.to_string)
            |> result.map(dom.NodeUpdate(node, _)),
          )
        RemoteImageNode(_) -> option.None
      }
    })
    |> option.values
    |> result.all,
  )

  let html = dom.update_nodes(tree.root, updates)
  let assets = images |> list.map(asset) |> option.values

  Page(..page, html:, assets: list.append(page.assets, assets))
}

fn asset(node: ImageNode) {
  case node {
    LocalImageNode(_, asset:) -> option.Some(asset)
    RemoteImageNode(_) -> option.None
  }
}

type ImageNode {
  LocalImageNode(node: dom.JSNodeRef, asset: assets.Asset)
  RemoteImageNode(node: dom.JSNodeRef)
}

fn read_image_node(node: dom.Node, page: Page) -> Result(ImageNode, String) {
  let attrs = dict.from_list(node.attrs)
  use src <- result.try(
    dict.get(attrs, "src")
    |> result.replace_error("could not read img src"),
  )

  resolve(node.node, page.path, src)
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

fn render_image(asset) -> Result(element.Element(a), String) {
  use resolved <- result.try(assets.resolve(asset))

  Ok(
    html.img([
      attribute.src(resolved.site_path),
      attribute.alt(
        fs.file_name_only(resolved.input_file)
        |> option.unwrap(""),
      ),
    ]),
  )
}
