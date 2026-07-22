import gleam/dict.{type Dict}
import gleam/list
import gleam/pair
import mellie.{type ElementTree}
import presentable_soup.{ElementNode, TextNode}

pub type Visited(a) {
  Visited(html: ElementTree, out: a)
}

type Visit(a) =
  fn(ElementTree) -> Visited(a)

/// Represents a server component
pub type Component(a) =
  #(String, Visit(a))

pub fn new(tag tag, visit visit) {
  #(tag, visit)
}

/// Rennders content breadth-first
fn render_rec(
  components: Dict(String, Visit(a)),
  el: ElementTree,
) -> #(ElementTree, List(a)) {
  case el {
    TextNode(_) -> #(el, [])
    ElementNode(tag:, attributes: _, children:) -> {
      let visit = components |> dict.get(tag)
      case visit {
        Ok(visit) -> {
          let visited = visit(el)
          #(visited.html, [visited.out])
        }
        Error(_) -> {
          let inner_results = children |> list.map(render_rec(components, _))
          let inner_children = inner_results |> list.map(pair.first)
          let inner_data =
            inner_results |> list.map(pair.second) |> list.flatten

          #(ElementNode(..el, children: inner_children), inner_data)
        }
      }
    }
  }
}

pub fn render(
  html: ElementTree,
  components: List(Component(a)),
) -> #(ElementTree, List(a)) {
  components |> dict.from_list |> render_rec(html)
}
