import gleam/dict.{type Dict}
import gleam/list
import mellie.{type ElementTree}
import presentable_soup.{ElementNode, TextNode}

type Visit(a) =
  fn(ElementTree) -> a

/// Represents a server component
pub type Component(a) =
  #(String, Visit(a))

pub fn new(tag tag, visit visit: Visit(a)) {
  #(tag, visit)
}

/// Rennders content depth-first
fn render_rec(
  components: Dict(String, Visit(ElementTree)),
  el: ElementTree,
) -> ElementTree {
  case el {
    TextNode(_) -> el
    ElementNode(tag:, attributes: _, children:) -> {
      let inner_children = children |> list.map(render_rec(components, _))
      let inner_updated = ElementNode(..el, children: inner_children)

      let visit = components |> dict.get(tag)

      case visit {
        Ok(visit) -> {
          visit(inner_updated)
        }
        Error(_) -> {
          inner_updated
        }
      }
    }
  }
}

pub fn render(
  html: ElementTree,
  components: List(Component(ElementTree)),
) -> ElementTree {
  components |> dict.from_list |> render_rec(html)
}
