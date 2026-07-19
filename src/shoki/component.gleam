import rendering/assets
import shoki/element

pub type Visited {
  Visited(html: element.Element, assets: List(assets.Asset))
}

type Visit =
  fn(element.Element) -> Visited

/// Represents a server component
pub opaque type Component {
  Component(tag: String, visit: Visit)
}

pub fn new(tag tag, visit visit) {
  Component(tag, visit)
}

pub fn render(doc: element.DocumentNode, components: List(Component)) {
  doc
}
