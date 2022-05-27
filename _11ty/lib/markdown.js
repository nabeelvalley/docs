const markdownIt = require('markdown-it')
const markdownItAnchor = require('markdown-it-anchor')
const markdownItHljs = require('markdown-it-highlightjs')
const markdownItKatex = require('markdown-it-katex')

const jsdom = require('jsdom')
const ipynb = require('ipynb2html')

const lib = markdownIt({
  html: true,
})
  .use(markdownItAnchor.default)
  .use(markdownItHljs)
  .use(markdownItKatex)
  .use((md) => {
    md.inline.State
  })

const convertMarkdownToHtml = (markdown) => {
  const base = lib.render(markdown)

  return base
    .replace(/<table /g, '<div class="scrollable"><table ')
    .replace(/<\/table> /g, '</table><div>')
}

const markdownLibrary = {
  render: convertMarkdownToHtml,
}

const convertJupyterToHtml = (content) => {
  const window = new jsdom.JSDOM().window
  const document = window.document

  const renderNotebook = ipynb.createRenderer(document)

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

module.exports = {
  convertMarkdownToHtml,
  convertJupyterToHtml,
  markdownLibrary,
}
