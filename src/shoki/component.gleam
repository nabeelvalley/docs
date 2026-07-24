import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/pair
import mellie.{type ElementTree}
import presentable_soup.{ElementNode, TextNode}
import shoki/internal/fs

pub type Visited(a) {
  Visited(html: ElementTree, out: a)
}

type Visit(a) =
  fn(option.Option(fs.Path), ElementTree) -> Visited(a)

/// Represents a server component
pub type Component(a) =
  #(String, Visit(a))

pub fn new(tag tag, visit visit: Visit(a)) {
  #(tag, visit)
}

/// Rennders content breadth-first
fn render_rec(
  components: Dict(String, Visit(a)),
  source,
  el: ElementTree,
) -> #(ElementTree, List(a)) {
  case el {
    TextNode(_) -> #(el, [])
    ElementNode(tag:, attributes: _, children:) -> {
      let visit = components |> dict.get(tag)
      case visit {
        Ok(visit) -> {
          let visited = visit(source, el)
          #(visited.html, [visited.out])
        }
        Error(_) -> {
          let inner_results =
            children |> list.map(render_rec(components, source, _))
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
  source,
  html: ElementTree,
  components: List(Component(a)),
) -> #(ElementTree, List(a)) {
  components |> dict.from_list |> render_rec(source, html)
}
