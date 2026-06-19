import { parseFragment, serialize } from 'parse5'
import { queryAll, replaceWith } from '@parse5/tools'


import { to_list as array_to_list }
// @ts-expect-error relative this file's location in build/dev/javascript/web
  from '../../gleam_javascript/gleam/javascript/array.mjs';

/**
 * @param {string} html
 */
export function pretty(html) {
  return serialize(parseFragment(html))
}

/**
 * @param {string} html
 * @param {string} tag
 * @param {(content: string, attrs: [key: string, value: string][]) => string} visit
 */
export function update(html, tag, visit) {
  const root = parseFragment(html)

  const nodes = queryAll(root, (node) => node.nodeName === tag)

  for (const node of nodes) {
    const attrs = node.attrs.map((/** @type {{ name: string; value: string; }} */ a) => [a.name,a.value])

    const updated = visit(serialize(node), array_to_list(attrs))
    const element = parseFragment(updated)
    replaceWith(node, ...element.childNodes)
  }


  return serialize(root)
}

