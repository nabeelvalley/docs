import { parseDocument, DomUtils } from 'htmlparser2'
import { render } from 'dom-serializer'
import hljs from 'highlight.js'
import { cloneNode, Element } from 'domhandler'

// @ts-expect-error types not available for package
import hljsGleam from '@gleam-lang/highlight.js-gleam'

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

hljs.registerLanguage('gleam', hljsGleam)

/**
 * @param {string} html
 */
export function highlight(html) {
  const root = parse(html)
  const pres = DomUtils.getElementsByTagName("pre", root.children)

  for (const pre of pres) {
    const codes = DomUtils.getElementsByTagName("code", pre.children)

    for (const el of codes) {
      const code = DomUtils.innerText(el)
      const lang = el.attribs["class"]?.split("-")?.[1] || 'test'

      let result;
      try {
        result = hljs.highlight(code, {
          language: lang,
        })
      } catch (err) {
        result = hljs.highlightAuto(code)
      }

      DomUtils.replaceElement(el.children[0], parse(result.value))
    }

    const figure = new Element("figure", {class: "codeblock"}, [cloneNode(pre, true)])
    DomUtils.replaceElement(pre, figure)
  }

  return render(root)
}
