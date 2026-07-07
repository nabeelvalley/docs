//// Using element.advanced to define custom elements is more reliable
//// since we have finer control over how children are treated

import lustre/element

pub fn site_snippet_preview(attrs, children: List(element.Element(a))) {
  element_with_children("site-snippet-preview", attrs, children)
}

fn element_with_children(name, attrs, children) {
  element.advanced("", name, attrs, children, False, False)
}

pub fn site_gallery(children) {
  element_with_children("site-gallery", [], children)
}

pub fn site_markdown(html) {
  element.unsafe_raw_html("", "site-markdown", [], html)
}
