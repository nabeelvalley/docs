const Converter = require('showdown').Converter
const jsdom = require('jsdom')
const ipynb = require('ipynb2html')

const externalLinksInNewWindow = {
  type: 'output',
  regex: /<a\shref[^>]+>/g,
  replace: (text) => {
    var url = text.match(/"(.*?)"/)[1]
    if (url.includes('http://') || url.includes('https://')) {
      return '<a href="' + url + '" target="_blank" rel="noopener noreferrer">'
    }
    return text
  },
}

const scrollableTables = {
  type: 'output',
  regex: /<table[^>]*>(?:.|\n)*?<\/table>/,
  replace: (text) => `<div class="scrollable">${text}</div>`,
}

const codeTab = {
  type: 'lang',
  regex: /^`([^`]*)`$/gm,
  replace: (text) =>
    `<p class="code-tab"><code>${text.slice(1, -1)}</code></p>`,
}

const convertMarkdownToHtml = (text) => {
  const converter = new Converter({
    headerLevelStart: 2,
    parseImgDimensions: true,
    extensions: [codeTab, externalLinksInNewWindow, scrollableTables],
    simplifiedAutoLink: true,
    tables: true,
    ghCompatibleHeaderId: true,
    disableForced4SpacesIndentedSublists: true,
  })

  const html = converter.makeHtml(text)

  return html
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

module.exports = { convertMarkdownToHtml, convertJupyterToHtml }
