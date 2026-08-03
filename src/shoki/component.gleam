import gleam/dict.{type Dict}
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option
import gleam/result
import mellie.{type ElementTree}
import presentable_soup.{ElementNode, TextNode}
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

pub type AsyncComponent {
  AsyncComponent(
    replace: ElementTree,
    render: fn() -> Promise(ShokiResult(ElementTree)),
  )
}

/// Visits all nodes that a component expects
pub fn render_async(
  source_path: option.Option(fs.Path),
  site_path: fs.SitePath,
  out_dir: fs.Path,
  html: ElementTree,
  component: Component(fn() -> Promise(Result(ElementTree, error.ShokiErr))),
) -> List(AsyncComponent) {
  let data = RenderData(source_path:, site_path:, out_dir:)
  let #(tag, visit) = component

  let children =
    mellie.find_all(html, mellie.get_children_by_tag(_, tag))
    |> list.map(fn(el) { visit(data, el) |> AsyncComponent(el, _) })

  let self = case mellie.has_tag(html, tag) {
    True -> [visit(data, html) |> AsyncComponent(html, _)]
    False -> []
  }

  list.append(self, children)
}
