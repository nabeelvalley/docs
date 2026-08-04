import gleam/dict.{type Dict}
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option
import gleam/result
import mellie/element.{type ElementTree, ElementNode, TextNode}
import shoki/error.{type ShokiResult}
import shoki/internal/fs

type Visit(a) =
  fn(RenderData, ElementTree) -> a

pub type Component(a) =
  #(String, Visit(a))

pub fn new(tag tag, visit visit: Visit(a)) {
  #(tag, visit)
}

pub type RenderData {
  RenderData(
    source_path: option.Option(fs.Path),
    site_path: fs.SitePath,
    out_dir: fs.Path,
  )
}

/// Updates content depth-first with the given components
fn render_rec(
  data,
  components: Dict(String, Visit(ShokiResult(ElementTree))),
  el: ElementTree,
) -> ShokiResult(ElementTree) {
  case el {
    TextNode(_) -> el |> Ok
    ElementNode(tag:, attributes: _, children:) -> {
      use inner_children <- result.try(
        children
        |> list.map(render_rec(data, components, _))
        |> error.collate_errors,
      )

      let inner_updated = ElementNode(..el, children: inner_children)

      let visit = components |> dict.get(tag)

      case visit {
        Ok(visit) -> {
          visit(data, inner_updated)
        }
        Error(_) -> {
          inner_updated |> Ok
        }
      }
    }
  }
}

/// Runs components over the given HTML depth-first
pub fn render(
  source_path: option.Option(fs.Path),
  site_path: fs.SitePath,
  out_dir: fs.Path,
  html: ElementTree,
  components: List(Component(ShokiResult(ElementTree))),
) {
  components
  |> dict.from_list
  |> render_rec(RenderData(source_path:, site_path:, out_dir:), _, html)
}

fn render_rec_async(
  data,
  tag,
  visit: fn(RenderData, ElementTree) -> Promise(ShokiResult(ElementTree)),
  el: ElementTree,
) -> Promise(ShokiResult(ElementTree)) {
  case el {
    TextNode(_) -> el |> Ok |> promise.resolve
    ElementNode(tag: t, attributes: _, children:) -> {
      let children_task =
        children
        |> list.map(render_rec_async(data, tag, visit, _))
        |> promise.await_list
        |> promise.map(error.collate_errors)

      children_task
      |> promise.try_await(fn(new_children) {
        let new_el = ElementNode(..el, children: new_children)
        case tag == t {
          False -> new_el |> Ok |> promise.resolve
          True -> visit(data, new_el)
        }
      })
    }
  }
}

/// Visits all nodes that a component expects
pub fn render_async(
  source_path: option.Option(fs.Path),
  site_path: fs.SitePath,
  out_dir: fs.Path,
  html: ElementTree,
  component: Component(Promise(Result(ElementTree, error.ShokiErr))),
) -> Promise(ShokiResult(ElementTree)) {
  let data = RenderData(source_path:, site_path:, out_dir:)
  let #(tag, visit) = component

  let result = render_rec_async(data, tag, visit, html)

  result
}
