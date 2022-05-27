const markdownIt = require('markdown-it')
const markdownItAnchor = require('markdown-it-anchor')

const jsdom = require('jsdom')
const ipynb = require('ipynb2html')

const markdownLibrary = markdownIt({
  html: true,
}).use(markdownItAnchor.default)

const convertMarkdownToHtml = (markdown) => {
  return markdownLibrary.render(markdown)
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
