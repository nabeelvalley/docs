import lustre/element
import rendering/assets

pub type Visited {
  Visited(html: element.Element(Nil), assets: List(assets.Asset))
}

type Visit =
  fn(element.Element(Nil)) -> Visited

/// Represents a server component
pub opaque type Component {
  Component(tag: String, visit: Visit)
}

pub fn new(tag tag, visit visit) {
  Component(tag, visit)
}

pub fn render(page: element.Element(Nil), components: List(Component)) {
  todo
}
