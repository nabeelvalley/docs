import { parseDocument, DomUtils } from 'htmlparser2'

import { render } from 'dom-serializer'

import { to_list as array_to_list }
  // @ts-expect-error relative this file's location in build/dev/javascript/web
  from '../../gleam_javascript/gleam/javascript/array.mjs';


/**
 * @param {string} html
 */
export function pretty(html) {
  const dom = parseDocument(html)
  return render(dom)
}

/**
 * @param {string} html
 */
function parse(html) {
  return parseDocument(html, {
    recognizeSelfClosing: true
  })
}

/**
 * @param {string} html
 * @param {string} tag
 */
export function getNodes(html, tag) {
  const root = parse(html)
  const els = DomUtils.getElementsByTagName(tag, root)

  const nodes = els.map(ref => {
    const attrs = ref.attributes.map((a) => [a.name, a.value])
    const html = render(ref.children)

    return [ref, array_to_list(attrs), html]
  })

  return [root, array_to_list(nodes)]
}


/**
 * @param {Parameters<render>[0]} root
 * @param {[Parameters<DomUtils['replaceElement']>[0], string][]} els
 */
export function updateNodes(root, els) {
  for (const el of els) {
    DomUtils.replaceElement(el[0], parse(el[1]))
  }

  return render(root)
}
