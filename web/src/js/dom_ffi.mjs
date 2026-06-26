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
 * @param {(content: string, attrs: [key: string, value: string][]) => Promise<string>} visit
 */
export async function update(html, tag, visit) {
  const root = parse(html)
  const els = DomUtils.getElementsByTagName(tag, root)

  for (const node of els) {
    const attrs = node.attributes.map((a) => [a.name, a.value])
    const updated = await visit(render(node.children), array_to_list(attrs))

    DomUtils.replaceElement(node, parse(updated))
  }

  return render(root)
}

