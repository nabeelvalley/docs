import { parseDocument, ElementType } from 'htmlparser2'
import render from 'dom-serializer';

import { Node, Text, Script, Style }
  // @ts-expect-error relative to current file
  from './html.mjs'

import { to_list as array_to_list }
  // @ts-expect-error relative this file's location in build/dev/javascript/web
  from '../../../gleam_javascript/gleam/javascript/array.mjs';

 
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
export function parse(html) {
  const doc = parseDocument(html, {
    recognizeSelfClosing: true
  })

  /**
   * @param {import('domhandler').ChildNode} node
   * @returns {object | undefined} parsed node
   */
  function convertNode(node) {
    if (node.type === ElementType.Text) {
      return new Text(node.data)
    }

    if (node.type === ElementType.Script) {
      const attrs = node.attributes.map(a => ([a.name, a.value]))
      const script = getInnerText(node)

      return new Script(array_to_list(attrs), script)
    }

    if (node.type === ElementType.Style) {
      const attrs = node.attributes.map(a => ([a.name, a.value]))
      const style = getInnerText(node)

      return new Style(array_to_list(attrs), style)
    }

    if (node.type === ElementType.Tag) {
      const children = node.children.map(convertNode).filter(Boolean)
      const attrs = node.attributes.map(a => ([a.name, a.value]))

      return new Node(node.name, array_to_list(attrs), array_to_list(children))
    }
  }

  return array_to_list(doc.children.map(convertNode).filter(Boolean))
}

/**
 * @param {import('domhandler').Element} node
 * @returns {string} innerText
 */
function getInnerText(node) {
  return node.children.filter(c => c.type === ElementType.Text).map(c => c.data).join("")
}
