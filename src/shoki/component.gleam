import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/result
import mellie.{type ElementTree}
import presentable_soup.{ElementNode, TextNode}
import shoki/error
import shoki/internal/fs

type Visit(a) =
  fn(RenderData, ElementTree) -> error.ShokiResult(a)

pub type Component(a) =
  #(String, Visit(a))

pub fn new(tag tag, visit visit: Visit(a)) {
  #(tag, visit)
}

pub type RenderData {
  RenderData(source_path: option.Option(fs.Path), site_path: fs.SitePath)
}

/// Updates content depth-first with the given components
fn render_rec(
  data,
  components: Dict(String, Visit(ElementTree)),
  el: ElementTree,
) -> error.ShokiResult(ElementTree) {
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
  html: ElementTree,
  components: List(Component(ElementTree)),
) {
  components
  |> dict.from_list
  |> render_rec(RenderData(source_path, site_path), _, html)
}
