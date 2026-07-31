import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import mellie.{type ElementTree}
import presentable_soup.{ElementNode, TextNode}
import shoki/internal/fs

type Visit(a) =
  fn(RenderData, ElementTree) -> a

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
) -> ElementTree {
  case el {
    TextNode(_) -> el
    ElementNode(tag:, attributes: _, children:) -> {
      let inner_children = children |> list.map(render_rec(data, components, _))
      let inner_updated = ElementNode(..el, children: inner_children)

      let visit = components |> dict.get(tag)

      case visit {
        Ok(visit) -> {
          visit(data, inner_updated)
        }
        Error(_) -> {
          inner_updated
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
) -> ElementTree {
  components
  |> dict.from_list
  |> render_rec(RenderData(source_path, site_path), _, html)
}
