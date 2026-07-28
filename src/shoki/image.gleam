import shoki
import shoki/component

pub fn with_sharp(pipeline) {
  pipeline
  |> shoki.with_components([component.new("img", fn(el) { todo })])
}
