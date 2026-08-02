//// Using element.advanced to define custom elements is more reliable
//// since we have finer control over how children are treated

import gleam/float
import js/sharp.{Horizontal, Vertical}
import mellie

pub fn site_snippet_preview(attrs, children: List(mellie.ElementTree)) {
  mellie.element("site-snippet-preview", attrs, children)
}

pub fn site_gallery(children) {
  mellie.element("site-gallery", [], children)
}

pub fn site_gallery_image(img) {
  mellie.element("site-gallery-image", [], [img])
}

pub fn site_markdown(html) {
  mellie.element("site-markdown", [], html)
}
