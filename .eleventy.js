const ipynb = require('ipynb2html')
const jsdom = require('jsdom')

const transformIpynb = require('./lib/transform-ipynb')

module.exports = function (config) {
  config.addPassthroughCopy('assets')
  // config.addPassthroughCopy('content/*/*/*.ipynb')

  // config.addTemplateFormats('ipynb')
  config.addExtension('ipynb', {
    compile: (str, inputPath) => (data) => {
      return 'Hello World'

      const window = new jsdom.JSDOM().window
      const document = window.document

      const renderNotebook = ipynb.createRenderer(document)
      const notebook = JSON.parse(str)

      const renderedContent = renderNotebook(notebook)

      renderedContent
        .querySelectorAll('style')
        .forEach((el) => el.parentNode.removeChild(el))

      const html = renderedContent.innerHTML
        .replace(/class="dataframe"/g, '')
        .replace(/border="1"/g, '')

      return html
    },
  })

  // config.addTransform('jupyterNotebook', transformIpynb)

  return {
    dir: {
      input: 'content',
    },
  }
}
