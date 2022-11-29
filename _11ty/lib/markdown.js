import markdownIt from 'markdown-it'
import markdownItAnchor from 'markdown-it-anchor'
import markdownItHljs from 'markdown-it-highlightjs'
import markdownItKatex from 'markdown-it-katex'
import markdownItToc from 'markdown-it-table-of-contents'

import { JSDOM } from 'jsdom'
import { createRenderer } from 'ipynb2html'

const lib = markdownIt({
  html: true,
})
  .use(markdownItAnchor)
  .use(markdownItHljs)
  .use(markdownItKatex)
  .use(markdownItToc, {
    includeLevel: [1, 2, 3, 4],
    containerHeaderHtml: `<details><summary>Contents</summary>`,
    containerFooterHtml: `</details>`,
  })

export const convertMarkdownToHtml = (markdown) => {
  const base = lib.render(markdown)

  return base
    .replace(/<table /g, '<div class="scrollable"><table ')
    .replace(/<\/table> /g, '</table><div>')
}

export const markdownLibrary = {
  render: convertMarkdownToHtml,
}

export const convertJupyterToHtml = (content) => {
  const window = new JSDOM().window
  const document = window.document

  const renderNotebook = createRenderer(document)

  const notebook = JSON.parse(content)

  // remove all inline style tags
  let renderedContent = renderNotebook(notebook)
  renderedContent
    .querySelectorAll('style')
    .forEach((el) => el.parentNode.removeChild(el))

  const html = renderedContent.innerHTML
    .replace(/class="dataframe"/g, '')
    .replace(/border="1"/g, '')

  return html
}
