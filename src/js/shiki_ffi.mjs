import { DomUtils } from 'htmlparser2'
import { render } from 'dom-serializer'
import { Element } from 'domhandler'
import { codeToHtml, bundledLanguages } from 'shiki'
import { parse } from './dom_ffi.mjs'


/**
 * @param {string} html
 */
export async function highlight(html) {
  const root = parse(html)
  const pres = DomUtils.getElementsByTagName("pre", root.children)

  for (const pre of pres) {
    const codes = DomUtils.getElementsByTagName("code", pre.children)

    let results = []
    for (const el of codes) {
      const code = DomUtils.innerText(el)
      /** @type {string | undefined} */
      let lang = el.attribs["class"]?.split("-")?.[1]
      lang = lang in bundledLanguages ? lang : "text"

      try {
        const result = await codeToHtml(code, {
          lang,
          themes: {
            light: 'github-light-high-contrast',
            dark: 'github-dark-high-contrast',
          }
        })

        results.push(parse(result))
      } catch (err) {
        console.warn("Error processing syntax highlights", code, err)
        throw new Error("Error processing syntax highlights", { cause: err })
      }
    }

    const figure = new Element("figure", { class: "codeblock" }, results)
    DomUtils.replaceElement(pre, figure)
  }

  return render(root)
}
