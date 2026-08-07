//// Using element.advanced to define custom elements is more reliable
//// since we have finer control over how children are treated

import mellie
import mellie/element.{type ElementTree}

pub fn site_snippet_preview(attrs, children: List(ElementTree)) {
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

pub fn site_photo_info(html) {
  mellie.element("site-photo-info", [], html)
}

pub fn site_photo_info_item(html) {
  mellie.element("site-photo-info-item", [], html)
}

pub fn site_photo_full(html) {
  mellie.element("site-photo-full", [], html)
}
