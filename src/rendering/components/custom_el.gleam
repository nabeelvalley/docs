//// Using element.advanced to define custom elements is more reliable
//// since we have finer control over how children are treated

import consts
import lustre/element

pub fn site_snippet_preview(attrs, children: List(element.Element(a))) {
  element_with_children("site-snippet-preview", attrs, children)
}

fn element_with_children(name, attrs, children) {
  element.advanced(consts.html_namespace, name, attrs, children, False, False)
}
